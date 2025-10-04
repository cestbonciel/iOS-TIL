// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ChatsForWebSocket",
    platforms: [
        .macOS(.v13)
    ],
    dependencies: [
        // 💧 Vapor 프레임워크 하나만 선언하면 됩니다.
        .package(url: "https://github.com/vapor/vapor", from: "4.89.0"),
    ],
    targets: [
        .executableTarget(
            name: "ChatsForWebSocket",
            dependencies: [
                // 저장소 이름이 'vapor'이므로 package 이름도 'vapor'로 수정합니다.
                .product(name: "Vapor", package: "vapor"),
            ]
        ),
    ]
)
