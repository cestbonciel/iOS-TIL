//
//  MessageBubble.swift
//  ChatDemoApp
//
//  Created by Nat Kim on 9/16/25.
//

import SwiftUI

struct MessageBubble: View {
	let message: ChatMessage
	let isMe: Bool

	var body: some View {
		HStack {
			if isMe { Spacer() }
			VStack(alignment: .leading, spacing: 4) {
				Text(message.userName)
					.font(.caption)
					.foregroundStyle(.secondary)
				Text(message.text)
					.padding(10)
					.background(isMe ? Color.blue : Color.gray.opacity(0.2))
					.foregroundColor(isMe ? .white : .primary)
					.clipShape(RoundedRectangle(cornerRadius: 12))
			}
			if !isMe { Spacer() }
		}
		.padding(.vertical, 2)
	}
}

#Preview {
	MessageBubble(
		message: ChatMessage(
			id: "1",
			userId: "me",
			userName: "Me",
			text: "Hello Preview 👋",
			createdAt: Date()
		),
		isMe: true
	)
}
