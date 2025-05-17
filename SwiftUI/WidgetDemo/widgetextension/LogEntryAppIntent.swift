//
//  LogEntryAppIntent.swift
//  widgetextensionExtension
//
//  Created by Nat Kim on 5/18/25.
//

import Foundation
import AppIntents


struct LogEntryAppIntent: AppIntent {
	
	static var title: LocalizedStringResource = "Log an entry to your streak."
	
	static var description = IntentDescription("Add 1 to your streak.")
	
	func perform() async throws -> some IntentResult & ReturnsValue {
		let data = DataService()
		data.log()
		
		return .result(value: data.progress())
	}
}
