//
//  TextViewModel.swift
//  GetURLFile
//
//  Created by Seohyun Kim on 2023/11/06.
//

import UIKit

class TextViewModel {
	var textData: [TextData] = []
	
	private var fileURL: URL {
		let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
		var directoryPath: URL = documentDirectory.appendingPathComponent("무제폴더")
		return documentDirectory.appendingPathComponent("article.txt")
	}
	
	init() {
		load()
	}
	
	func makeFileManager() {
		let fileManager = FileManager.default
		let documentPath: URL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
		var directoryPath: URL = documentPath.appendingPathComponent("무제폴더")
		do {
			try fileManager.createDirectory(at: directoryPath, withIntermediateDirectories: false)
		} catch {
			print(error.localizedDescription)
		}
	}
	
	func add(_ article: String, date: Date) {
		let new = TextData(article: article, creationDate: date)
		textData.append(new)
		save()
	}
	
	private func save() {
		do {
			let data = try JSONEncoder().encode(textData)
			try data.write(to: fileURL)
		} catch {
			print("Error saving reading list: \(error)")
		}
	}
	
	func load() {
		do {
			let data = try Data(contentsOf: fileURL)
			textData = try JSONDecoder().decode([TextData].self, from: data)
		} catch {
			print("Error loading reading list: \(error)")
		}
	}
}
