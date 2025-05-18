//
//  DataService.swift
//  widgetextensionExtension
//
//  Created by Nat Kim on 5/18/25.
//

import Foundation
import SwiftUI

struct DataService {
	
	@AppStorage(
		"streak",
		store: UserDefaults(
			suiteName: "group.com.seohyunKim.iOS.WidgetDemo"
		)
	)
	private var streak = 0
	
	func log() {
		//streak += 1
		let configIntent = StreakConfigIntent()
		let targetStreak = configIntent.targetStreak
		
		if streak < targetStreak {
			streak += 1
		}
	}
	
	func progress() -> Int {
		return streak
	}
	
	func isGoalReached(target: Int) -> Bool {
		return streak >= target
	}
}
