//
//  MockChatService.swift
//  ChatDemoApp
//
//  Created by Nat Kim on 9/16/25.
//

import Foundation

final class MockChatService: FirebaseChatService {
	override func listenMessages(onChange: @escaping ([ChatMessage]) -> Void) {
		let demo = [
			ChatMessage(id: "1", userId: "me", userName: "Me", text: "안녕 👋", createdAt: Date()),
			ChatMessage(id: "2", userId: "other", userName: "Alice", text: "Hello from web!", createdAt: Date())
		]
		onChange(demo)
	}

	override func sendMessage(userId: String, userName: String, text: String) {
		print("Mock send: \(text)")
	}
}
