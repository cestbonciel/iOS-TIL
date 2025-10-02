import Vapor
import Foundation
import NIOSSL // Vapor에서 TLS 설정을 위해 추가

// 클라이언트 정보를 저장하는 구조체
struct ClientInfo {
    let ws: WebSocket
    let emoji: String
    let color: String
    let name: String
}

// 여러 동시 요청으로부터 웹소켓 연결을 안전하게 관리하기 위한 Actor
actor WebSocketClients {
    var connections: [UUID: ClientInfo] = [:]
    let emojis = ["🦊", "🐱", "🐶", "🐼", "🐨", "🐯", "🦁", "🐮", "🐷", "🐸", "🦄", "🐙", "🦋", "🐝", "🦀", "🐳"]
    let colors = ["#FF6B6B", "#4ECDC4", "#45B7D1", "#FFA07A", "#98D8C8", "#F7DC6F", "#BB8FCE", "#85C1E2", "#F8B195", "#C06C84"]
    var clientCounter = 0

    func add(_ ws: WebSocket) -> UUID {
        let id = UUID()
        clientCounter += 1
        let emoji = emojis[clientCounter % emojis.count]
        let color = colors[clientCounter % colors.count]
        let name = "User \(clientCounter)"
        
        let clientInfo = ClientInfo(ws: ws, emoji: emoji, color: color, name: name)
        connections[id] = clientInfo
        print("✅ Client connected: \(emoji) \(name). Total clients: \(connections.count)")
        
        // 새 클라이언트에게 자신의 정보 전송
        ws.send("{\"type\":\"welcome\",\"emoji\":\"\(emoji)\",\"color\":\"\(color)\",\"name\":\"\(name)\"}")
        
        return id
    }

    func remove(_ id: UUID) {
        if let client = connections[id] {
            print("❌ Client disconnected: \(client.emoji) \(client.name). Total clients: \(connections.count - 1)")
        }
        connections[id] = nil
    }

    func sendToAll(_ text: String, from senderId: UUID) {
        guard let sender = connections[senderId] else { return }
        
        let message = "{\"type\":\"message\",\"text\":\"\(text)\",\"emoji\":\"\(sender.emoji)\",\"color\":\"\(sender.color)\",\"name\":\"\(sender.name)\"}"
        
        for (id, client) in connections {
            if id == senderId {
                // 발신자에게는 "나" 표시
                let selfMessage = "{\"type\":\"message\",\"text\":\"\(text)\",\"emoji\":\"\(sender.emoji)\",\"color\":\"\(sender.color)\",\"name\":\"나\",\"isSelf\":true}"
                client.ws.send(selfMessage)
            } else {
                client.ws.send(message)
            }
        }
    }
}

@main
struct App {
    static func main() async throws {
        var env = try Environment.detect()
        try LoggingSystem.bootstrap(from: &env)

        let app = try await Application.make(env)
        
        // 서버 포트 설정 (HTTPS용)
        app.http.server.configuration.port = 8443
        app.http.server.configuration.hostname = "0.0.0.0"
        
        // defer 블록을 Task로 감싸고, 비동기 종료 메서드를 호출하여 경고를 해결합니다.
        defer {
            Task {
                do {
                    try await app.asyncShutdown()
                } catch {
                    print("❌ Failed to shut down application: \(error)")
                }
            }
        }

        let clients = WebSocketClients()

        // TLS 설정
        do {
            app.http.server.configuration.tlsConfiguration = .makeServerConfiguration(
                certificateChain: try NIOSSLCertificate.fromPEMFile("cert.pem").map { .certificate($0) },
                privateKey: .privateKey(try NIOSSLPrivateKey(file: "key.pem", format: .pem))
            )
            print("✅ TLS configuration loaded successfully")
        } catch {
            print("❌ Failed to configure TLS: \(error)")
            print("💡 Make sure cert.pem and key.pem files exist in the project root")
        }

        // 정적 파일 서빙 설정
        app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
        
        // 루트 경로에서 index.html 서빙
        app.get { req -> Response in
            let htmlPath = app.directory.publicDirectory + "index.html"
            let html = try String(contentsOfFile: htmlPath)
            
            var headers = HTTPHeaders()
            headers.add(name: .contentType, value: "text/html; charset=utf-8")
            return Response(status: .ok, headers: headers, body: .init(string: html))
        }

        app.webSocket("chat") { _, ws in
            let id = await clients.add(ws)

            ws.onText { _, text in
                print("💬 Received message: \(text)")
                await clients.sendToAll(text, from: id)
            }

            // .whenComplete는 동기 클로저를 기대하므로,
            // 비동기 함수(await)를 호출하기 위해 Task로 감싸줍니다.
            ws.onClose.whenComplete { _ in Task { await clients.remove(id) } }
        }

        print("🚀 Server starting on https://localhost:8443")
        print("🔗 WebSocket endpoint: wss://localhost:8443/chat")
        try await app.execute()
    }
}
