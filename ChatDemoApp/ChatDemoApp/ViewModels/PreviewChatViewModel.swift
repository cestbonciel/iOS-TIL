//
//  PreviewChatViewModel.swift
//  ChatDemoApp
//
//  Created by Nat Kim on 9/16/25.
//

import Foundation

@MainActor
final class PreviewChatViewModel: ChatViewModel {
	init() {
		super.init(service: MockChatService())
		self.messages = [
			ChatMessage(id: "1", userId: "me", userName: "Me", text: "안녕 👋", createdAt: Date()),
			ChatMessage(id: "2", userId: "other", userName: "Alice", text: "Hello from web!", createdAt: Date()),
			ChatMessage(id: "3", userId: "me", userName: "Me", text: "이건 프리뷰 전용 메시지야", createdAt: Date())
		]
	}
}
