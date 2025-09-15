//
//  ChatMessage.swift
//  ChatDemoApp
//
//  Created by Nat Kim on 9/16/25.
//

import Foundation
import FirebaseFirestore

struct ChatMessage: Identifiable, Codable {
	var id: String
	var userId: String
	var userName: String
	var text: String
	var createdAt: Date
	
	init(
		id: String,
		userId: String,
		userName: String,
		text: String,
		createdAt: Date
	) {
		self.id = id
		self.userId = userId
		self.userName = userName
		self.text = text
		self.createdAt = createdAt
	}
	
	init?(id: String, data: [String: Any]) {
		guard let userId = data["userId"] as? String,
			  let userName = data["userName"] as? String,
			  let text = data["text"] as? String,
			  let ts = data["createdAt"] as? Timestamp else { return nil }
		self.init(id: id, userId: userId, userName: userName, text: text, createdAt: ts.dateValue())
	}
	
	func toDict() -> [String: Any] {
		["userId": userId, "userName": userName, "text": text, "createdAt": FieldValue.serverTimestamp()]
	}
}
