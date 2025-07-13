//
//  SmartWidgetView.swift
//  widgetextensionExtension
//
//  Created by Nat Kim on 7/13/25.
//

import SwiftUI

// MARK: - Smart Widget View (새로 추가)

struct SmartWidgetView: View {
	let entry: CoffeeEntry
	
	var body: some View {
		VStack(spacing: 6) {
			// 🎨 상단: 건강 상태 + 시간별 메시지
			HStack {
				if let status = entry.healthStatus {
					Image(systemName: status.symbolName)
						.foregroundColor(status.color)
						.font(.title2)
				} else {
					Image(systemName: "cup.and.saucer")
						.foregroundColor(.gray)
						.font(.title2)
				}
				
				VStack(alignment: .leading, spacing: 2) {
					Text(contextualMessage)
						.font(.caption2)
						.fontWeight(.medium)
						.foregroundColor(entry.healthStatus?.color ?? .gray)
					
					Text("오늘 \(entry.totalCaffeine)mg")
						.font(.title3)
						.fontWeight(.bold)
				}
				
				Spacer()
			}
			
			// 중간: 진행률 바 (시각적 개선)
			ProgressView(value: min(Double(entry.totalCaffeine) / 400.0, 1.0))
				.tint(entry.healthStatus?.color ?? .gray)
				.scaleEffect(y: 2)
			
			// 하단: 마지막 커피 + 액션 힌트
			if let lastCoffee = entry.lastCoffee {
				HStack {
					VStack(alignment: .leading, spacing: 1) {
						Text(lastCoffee.name)
							.font(.caption2)
							.lineLimit(1)
						Text(timeAgoString(from: lastCoffee.timestamp))
							.font(.caption2)
							.foregroundColor(.secondary)
					}
					
					Spacer()
					
					Text(actionHint)
						.font(.caption2)
						.foregroundColor(.blue)
				}
			} else {
				Text("☕ 탭하여 커피 추가")
					.font(.caption2)
					.foregroundColor(.blue)
					.frame(maxWidth: .infinity)
			}
		}
		.padding(8)
		.widgetURL(createSmartDeepLink()) // 🔗 스마트 딥링크
	}
	
	// 🧠 시간과 카페인 수준에 따른 맞춤 메시지
	private var contextualMessage: String {
		let hour = Calendar.current.component(.hour, from: Date())
		let caffeine = entry.totalCaffeine
		
		switch (caffeine, hour) {
		case (400..., _): return "⛔ 한도 초과!"
		case (300..., 18...23): return "🌙 수면 주의"
		case (200..., 7...9): return "🌅 좋은 아침"
		case (100..., 13...15): return "☕ 오후 충전"
		case (0..<100, 20...23): return "😴 좋은 밤"
		default: return "☕ 커피 타임"
		}
	}
	
	// 💡 다음 액션 힌트
	private var actionHint: String {
		let hour = Calendar.current.component(.hour, from: Date())
		let caffeine = entry.totalCaffeine
		
		switch (caffeine, hour) {
		case (400..., _): return "💧 물"
		case (300..., 16...): return "🚫 중단"
		case (0..<200, 7...11): return "➕ 추가"
		case (0..<200, 13...15): return "☕ 오후"
		default: return "📊 확인"
		}
	}
	
	// 🔗 스마트 딥링크 생성
	private func createSmartDeepLink() -> URL? {
		let hour = Calendar.current.component(.hour, from: Date())
		let caffeine = entry.totalCaffeine
		
		// 상황별 딥링크
		switch (caffeine, hour) {
		case (400..., _):
			return URL(string: "coffeepushwidget://hydration-alert")
		case (0..<200, 7...11):
			return URL(string: "coffeepushwidget://morning-coffee")
		case (0..<200, 13...15):
			return URL(string: "coffeepushwidget://afternoon-coffee")
		default:
			return URL(string: "coffeepushwidget://add-coffee")
		}
	}
	
	private func timeAgoString(from date: Date) -> String {
		let interval = Int(Date().timeIntervalSince(date))
		let hours = interval / 3600
		let minutes = (interval % 3600) / 60
		
		if hours > 0 { return "\(hours)h" }
		else if minutes > 0 { return "\(minutes)m" }
		else { return "now" }
	}
}
