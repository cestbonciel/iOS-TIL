//
//  ChatView.swift
//  ChatDemoApp
//
//  Created by Nat Kim on 9/16/25.
//

import SwiftUI

struct ChatView: View {
	@StateObject var viewModel: ChatViewModel
	
	var body: some View {
		VStack {
			ScrollViewReader { proxy in
				messagesList
					.onChange(of: viewModel.messages.count) { _ in
						if let lastId = viewModel.messages.last?.id {
							withAnimation {
								proxy.scrollTo(lastId, anchor: .bottom)
							}
						}
					}
			}
			Divider()
			inputBar
		}
	}
	
	// MARK: - Subviews
	
	private var messagesList: some View {
		// 바깥에서 한 번만 캡쳐해서 타입 추론 단순화
		let myID = viewModel.userId
		return ScrollView {
			LazyVStack(alignment: .leading, spacing: 8) {
				ForEach(viewModel.messages) { msg in
					// 계산 따로 빼기
					let isMe = (msg.userId == myID)
					MessageRow(message: msg, isMe: isMe)
				}
			}
			.padding()
		}
	}
	
	private var inputBar: some View {
		HStack {
			TextField("메시지 입력…", text: $viewModel.input)
				.textFieldStyle(.roundedBorder)
				.submitLabel(.send)
				.onSubmit { viewModel.send() }
			
			Button(action: { viewModel.send() }) {
				Image(systemName: "paperplane.fill")
					.foregroundColor(.white)
					.padding(8)
					.background(Color.blue)
					.clipShape(Circle())
			}
		}
		.padding()
	}
}

// MARK: - Small row to simplify the type-checker
private struct MessageRow: View {
	let message: ChatMessage
	let isMe: Bool
	
	var body: some View {
		MessageBubble(message: message, isMe: isMe)
	}
}
#Preview {
	ChatView(viewModel: PreviewChatViewModel())
}
