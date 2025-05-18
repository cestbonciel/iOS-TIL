//
//  DataService.swift
//  widgetextensionExtension
//
//  Created by Nat Kim on 5/18/25.
//

import Foundation
import SwiftUI
import WidgetKit

struct DataService {
	
	@AppStorage(
		"streak",
		store: UserDefaults(
			suiteName: "group.com.seohyunKim.iOS.WidgetDemo"
		)
	)
	private var streak = 0

	@AppStorage("targetStreak", store: UserDefaults(suiteName: "group.com.seohyunKim.iOS.WidgetDemo"))
	private var savedTargetStreak = 50

	@AppStorage("progressColor", store: UserDefaults(suiteName: "group.com.seohyunKim.iOS.WidgetDemo"))
	private var savedProgressColor = "blue"
	
	func log() {
		//streak += 1
		let configIntent = StreakConfigIntent()
		//let targetStreak = configIntent.targetStreak
		
//		if streak < targetStreak {
//			streak += 1
//		}
		if !isGoalReached(target: configIntent.targetStreak) {
			streak += 1
		}
	}
	
	func progress() -> Int {
		return streak
	}
	
	func isGoalReached(target: Int) -> Bool {
		return streak >= target
	}
	
	func reset() {
		streak = 0
	}
	
	func saveWidgetConfig(target: Int, color: String) {
		savedTargetStreak = target
		savedProgressColor = color
		WidgetCenter.shared.reloadTimelines(ofKind: "widgetextension")
	}
}
