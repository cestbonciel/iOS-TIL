//
//  SharedModel.swift
//  CoffeePushWidget
//
//  Created by Nat Kim on 6/24/25.
//
import Foundation
import SwiftUI
import WidgetKit

struct CoffeeEntry: TimelineEntry {
	let date: Date
	let totalCaffeine: Int
	let lastCoffee: CoffeeRecord?
	let recentEntries: [CoffeeRecord]
	
	// 새로운 필드를 옵셔널로 추가 (기존 코드 호환성 유지)
	let healthStatus: CaffeineHealthStatus?
	
	// 기존 생성자 (기존 코드와 호환)
	init(date: Date, totalCaffeine: Int, lastCoffee: CoffeeRecord?, recentEntries: [CoffeeRecord]) {
		self.date = date
		self.totalCaffeine = totalCaffeine
		self.lastCoffee = lastCoffee
		self.recentEntries = recentEntries
		self.healthStatus = Self.determineHealthStatus(totalCaffeine: totalCaffeine)
	}
	
	// 새로운 생성자 (향후 사용)
	init(date: Date, totalCaffeine: Int, lastCoffee: CoffeeRecord?, recentEntries: [CoffeeRecord], healthStatus: CaffeineHealthStatus) {
		self.date = date
		self.totalCaffeine = totalCaffeine
		self.lastCoffee = lastCoffee
		self.recentEntries = recentEntries
		self.healthStatus = healthStatus
	}
	
	private static func determineHealthStatus(totalCaffeine: Int) -> CaffeineHealthStatus {
		let hour = Calendar.current.component(.hour, from: Date())
		
		switch totalCaffeine {
		case 400...:
			return .excessive
		case 320..<400:
			return hour >= 16 ? .warning : .high
		case 200..<320:
			return .moderate
		case 1..<200:
			return .low
		default:
			return .none
		}
	}
}

struct CoffeeRecord: Codable, Identifiable {
	let id: UUID
	let name: String
	let caffeine: Int
	let timestamp: Date
}

// MARK: - 새로 추가되는 모델들

enum CaffeineHealthStatus: String, CaseIterable, Codable {
	case none = "none"
	case low = "low"
	case moderate = "moderate"
	case high = "high"
	case warning = "warning"
	case excessive = "excessive"
	
	var color: Color {
		switch self {
		case .none: return .gray
		case .low: return .blue
		case .moderate: return .green
		case .high: return .orange
		case .warning: return .red
		case .excessive: return .purple
		}
	}
	
	var symbolName: String {
		switch self {
		case .none: return "moon.zzz"
		case .low: return "cup.and.saucer"
		case .moderate: return "checkmark.circle"
		case .high: return "exclamationmark.triangle"
		case .warning: return "exclamationmark.octagon"
		case .excessive: return "octagon"
		}
	}
	
	var description: String {
		switch self {
		case .none: return "시작하세요"
		case .low: return "적당해요"
		case .moderate: return "좋은 수준"
		case .high: return "주의하세요"
		case .warning: return "경고"
		case .excessive: return "과다 섭취"
		}
	}
}

struct SmartNotification {
	let title: String
	let body: String
	let customData: [String: Any]
	
	init(title: String, body: String, customData: [String: Any] = [:]) {
		self.title = title
		self.body = body
		self.customData = customData
	}
}
