//
//  FirebaseChatService.swift
//  ChatDemoApp
//
//  Created by Nat Kim on 9/16/25.
//

import Foundation
import FirebaseFirestore

final class FirebaseChatService {
	private let db = Firestore.firestore()
	private let room = "general"
	
	func listenMessages(onChange: @escaping ([ChatMessage]) -> Void) {
		db.collection("rooms").document(room).collection("messages")
			.order(by: "createdAt", descending: false)
			.addSnapshotListener { snapshot, error in
				guard let documents = snapshot?.documents else { return }
				let msgs = documents.compactMap { ChatMessage(id: $0.documentID, data: $0.data()) }
				onChange(msgs)
			}
	}
	
	func sendMessage(userId: String, userName: String, text: String) {
		let ref = db.collection("rooms").document(room).collection("messages").document()
		let msg = ChatMessage(id: ref.documentID, userId: userId, userName: userName, text: text, createdAt: Date())
		ref.setData(msg.toDict())
	}
}
