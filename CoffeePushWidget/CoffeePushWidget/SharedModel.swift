//
//  SharedModel.swift
//  CoffeePushWidget
//
//  Created by Nat Kim on 6/24/25.
//
import Foundation
import WidgetKit

struct CoffeeEntry: TimelineEntry {
	let date: Date
	let totalCaffeine: Int
	let lastCoffee: CoffeeRecord?
	let recentEntries: [CoffeeRecord]
}

struct CoffeeRecord: Codable, Identifiable {
	let id: UUID
	let name: String
	let caffeine: Int
	let timestamp: Date
}
