//
//  LogEntry.swift
//  widgetextensionExtension
//
//  Created by Nat Kim on 5/18/25.
//

import Foundation
import AppIntents
import SwiftUI


struct LogEntry: AppIntent {
	
	static var title: LocalizedStringResource = "Log a streak."
	
	static var description = IntentDescription("Add 1 to your streak.")
	
	func perform() async throws -> some IntentResult & ReturnsValue<Int> {
		let data = DataService()
		data.log()
		
		return .result(value: data.progress())
	}
}
