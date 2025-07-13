//
//  SmartWidgetView.swift
//  widgetextensionExtension
//
//  Created by Nat Kim on 7/13/25.
//

import SwiftUI
struct SmartWidgetView: View {
	let entry: CoffeeEntry
	
	var body: some View {
		VStack(spacing: 8) {
			HStack {
				Text(contextualMessage)
					.font(.caption)
					.fontWeight(.medium)
					.foregroundColor(entry.healthStatus?.color ?? .gray)
					.lineLimit(1)
				
				Spacer()
			}
			
			VStack(spacing: 4) {
				Text("\(entry.totalCaffeine)mg")
					.font(.system(size: 36, weight: .bold, design: .rounded))
					.foregroundColor(.primary)
					.minimumScaleFactor(0.8)
				
				let percentage = min(Double(entry.totalCaffeine) / 400.0, 1.0)
				let progressColor = getProgressColor(percentage: percentage)
				
				ProgressView(value: percentage)
					.tint(progressColor)
					.scaleEffect(y: 2)
					.animation(.easeInOut(duration: 0.3), value: percentage)
			}
			
			Spacer()
			
			if let lastCoffee = entry.lastCoffee {
				HStack {
					VStack(alignment: .leading, spacing: 2) {
						Text(lastCoffee.name)
							.font(.caption)
							.fontWeight(.medium)
							.lineLimit(1)
							.fixedSize(horizontal: false, vertical: true) // 말줄임표 방지
						Text(timeAgoString(from: lastCoffee.timestamp))
							.font(.caption2)
							.foregroundColor(.secondary)
					}
					
					Spacer()
				}
			} else {
				HStack {
					Text("탭하여 커피 추가")
						.font(.caption)
						.fontWeight(.medium)
						.foregroundColor(.blue)
						.lineLimit(1)
					
					Spacer()
				}
			}
		}
		.padding(10)
		.background(
			RoundedRectangle(cornerRadius: 12)
				.fill(Color(.systemGray6))
				.shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1)
		)
		.widgetURL(URL(string: "coffeepushwidget://add-coffee")) // 단순히 앱 열기
	}
	
	private func getProgressColor(percentage: Double) -> Color {
		switch percentage {
		case 0..<0.25: return .blue
		case 0.25..<0.5: return .green
		case 0.5..<0.75: return .orange
		case 0.75..<1.0: return .red
		default: return .purple
		}
	}
	
	private var contextualMessage: String {
		let hour = Calendar.current.component(.hour, from: Date())
		let caffeine = entry.totalCaffeine
		
		switch (caffeine, hour) {
		case (400..., _): return "⛔ 한도 초과"
		case (300..., 18...23): return "🌙 수면 주의"
		case (200..., 7...9): return "🌅 좋은 아침"
		case (100..., 13...15): return "☕ 오후 시간"
		case (0..<100, 20...23): return "😴 좋은 밤"
		default: return "☕ 커피 타임"
		}
	}
	
	private func timeAgoString(from date: Date) -> String {
		let interval = Int(Date().timeIntervalSince(date))
		let hours = interval / 3600
		let minutes = (interval % 3600) / 60
		
		if hours > 0 { return "\(hours)시간 전" }
		else if minutes > 0 { return "\(minutes)분 전" }
		else { return "방금 전" }
	}
}
