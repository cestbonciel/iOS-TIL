//
//  MediumWidgetView.swift
//  widgetextensionExtension
//
//  Created by Nat Kim on 7/14/25.
//

import SwiftUI
import WidgetKit

struct MediumWidgetView: View {
	let entry: CoffeeEntry
	
	var body: some View {
		HStack(spacing: 12) {
			VStack(spacing: 6) {
				if let status = entry.healthStatus {
					Image(systemName: status.symbolName)
						.foregroundColor(status.color)
						.font(.title3)
				} else {
					Image(systemName: "cup.and.saucer")
						.foregroundColor(.gray)
						.font(.title3)
				}
				
				Text("\(entry.totalCaffeine)")
					.font(.system(size: 24, weight: .bold, design: .rounded))  // 🎯 크기 축소
					.foregroundColor(.primary)
				
				Text("mg")
					.font(.caption)
					.foregroundColor(.secondary)
				
				// 진행률 바
				let percentage = min(Double(entry.totalCaffeine) / 400.0, 1.0)
				let progressColor = getProgressColor(percentage: percentage)
				
				ProgressView(value: percentage)
					.tint(progressColor)
					.scaleEffect(y: 1.2)
					.frame(width: 50)
				
				Text(getStatusText(caffeine: entry.totalCaffeine))
					.font(.caption2)
					.fontWeight(.medium)
					.foregroundColor(progressColor)
					.lineLimit(1)
			}
			.frame(width: 80)
			Divider()
			
			// 🎨 오른쪽: 기록 정보 (공간 최적화)
			VStack(alignment: .leading, spacing: 6) {
				// 헤더: 가로 배치
				HStack {
					Text("오늘의 기록")
						.font(.caption)
						.fontWeight(.semibold)
					
					Spacer()
					
					HStack(spacing: 4) {
						Text("\(entry.totalCaffeine)mg")
							.font(.caption2)
							.fontWeight(.semibold)
							.foregroundColor(.blue)
						
						Text("•")
							.font(.caption2)
							.foregroundColor(.secondary)
						
						Text("\(entry.recentEntries.count)잔")
							.font(.caption2)
							.fontWeight(.medium)
							.foregroundColor(.secondary)
					}
				}
				
				if entry.recentEntries.isEmpty {
					VStack(spacing: 3) {
						Image(systemName: "cup.and.saucer")
							.font(.caption)
							.foregroundColor(.gray.opacity(0.6))
						
						Text("기록 없음")
							.font(.caption2)
							.foregroundColor(.secondary)
					}
					.frame(maxWidth: .infinity)
					.padding(.vertical, 6)
				} else {
					
					ForEach(Array(entry.recentEntries.prefix(2).enumerated()), id: \.offset) { index, record in
						HStack(spacing: 6) {
							Circle()
								.fill(getCaffeineColor(record.caffeine).opacity(0.2))
								.frame(width: 16, height: 16)
								.overlay(
									Image(systemName: "cup.and.saucer.fill")
										.foregroundColor(getCaffeineColor(record.caffeine))
										.font(.caption2)
								)
							
							VStack(alignment: .leading, spacing: 1) {
								Text(record.name)
									.font(.caption2)
									.fontWeight(.medium)
									.lineLimit(1)
								
								Text(timeAgoString(from: record.timestamp))
									.font(.caption2)
									.foregroundColor(.secondary)
							}
							
							Spacer()
							
							Text("\(record.caffeine)mg")
								.font(.caption2)
								.fontWeight(.semibold)
								.foregroundColor(getCaffeineColor(record.caffeine))
						}
					}
					
					if entry.recentEntries.count > 2 {
						HStack {
							Text("+ \(entry.recentEntries.count - 2)개 더")
								.font(.caption2)
								.foregroundColor(.secondary)
							Spacer()
						}
					}
				}
			}
			.frame(maxWidth: .infinity)
		}
		.padding(10)
		.background(
			RoundedRectangle(cornerRadius: 12)
				.fill(Color(.systemGray6))
				.shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1)
		)
		.widgetURL(URL(string: "coffeepushwidget://add-coffee"))
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
	
	private func getStatusText(caffeine: Int) -> String {
		switch caffeine {
		case 0..<100: return "시작"
		case 100..<200: return "좋음"
		case 200..<300: return "적정"
		case 300..<400: return "주의"
		default: return "과다"
		}
	}
	
	private func getCaffeineColor(_ caffeine: Int) -> Color {
		switch caffeine {
		case 0..<75: return .green
		case 75..<150: return .blue
		case 150..<200: return .orange
		default: return .red
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
