//
//  TextData.swift
//  GetURLFile
//
//  Created by Seohyun Kim on 2023/11/06.
//

import Foundation

struct TextData: Codable, Equatable, Identifiable {
	let article: String
	let creationDate: Date
	var id: Date { return creationDate }
	
	static func example() -> TextData {
		TextData(article: "This is Sample Data.", creationDate: Date())
	}
}
