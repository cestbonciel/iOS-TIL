//
//  ChatViewModel.swift
//  ChatDemoApp
//
//  Created by Nat Kim on 9/16/25.
//

import Foundation

@MainActor
final class ChatViewModel: ObservableObject {
	@Published var messages: [ChatMessage] = []
	@Published var input: String = ""

	private let service: FirebaseChatService
	private let userId: String = UUID().uuidString
	private let userName: String = "iOS-\(Int.random(in: 100...999))"

	init(service: FirebaseChatService) {
		self.service = service
		service.listenMessages { [weak self] msgs in
			Task { @MainActor in
				self?.messages = msgs
			}
		}
	}

	func send() {
		let text = input.trimmingCharacters(in: .whitespacesAndNewlines)
		guard !text.isEmpty else { return }
		service.sendMessage(userId: userId, userName: userName, text: text)
		input = ""
	}
}

