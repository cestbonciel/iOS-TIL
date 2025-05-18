//
//  StreakConfigIntent.swift
//  widgetextensionExtension
//
//  Created by Nat Kim on 5/18/25.
//

import AppIntents
import WidgetKit
import SwiftUI

struct StreakConfigIntent: WidgetConfigurationIntent {
	static var title: LocalizedStringResource = "Streak Widget"
	static var description = IntentDescription("streak widget setting")
	
	@Parameter(title: "목표 숫자", default: 50)
	var targetStreak: Int
	
	@Parameter(title: "색상", default: .blue)
	var progressColor: ProgressColor
	
}

enum ProgressColor: String, AppEnum {
	case blue, green, red, purple, orange
	
	static var typeDisplayRepresentation: TypeDisplayRepresentation {
		TypeDisplayRepresentation(name: "색상")
	}
	
	static var caseDisplayRepresentations: [ProgressColor: DisplayRepresentation] {
		[
			.blue: DisplayRepresentation(title: "파란색"),
			.green: DisplayRepresentation(title: "초록색"),
			.red: DisplayRepresentation(title: "빨간색"),
			.purple: DisplayRepresentation(title: "보라색"),
			.orange: DisplayRepresentation(title: "주황색"),
		]
	}
}
