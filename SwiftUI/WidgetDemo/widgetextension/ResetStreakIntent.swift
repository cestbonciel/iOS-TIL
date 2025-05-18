//
//  ResetStreakIntent.swift
//  widgetextensionExtension
//
//  Created by Nat Kim on 5/19/25.
//

import AppIntents
import SwiftUI

struct ResetStreakIntent: AppIntent {
	static var title: LocalizedStringResource = "Reset streak"
	static var description = IntentDescription("Reset your streak to zero.")
	
	func perform() async throws -> some IntentResult & ReturnsValue<Int> {
		let data = DataService()
		data.reset() 
		
		return .result(value: 0)
	}
}
