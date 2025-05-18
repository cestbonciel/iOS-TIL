//
//  widgetextension.swift
//  widgetextension
//
//  Created by Nat Kim on 5/18/25.
//

import WidgetKit
import SwiftUI

/// Provider: the supplier of the data
/// TimelineProvider -> AppIntentTimelineProvider
struct Provider: AppIntentTimelineProvider {
	let data = DataService()
	
	func placeholder(in context: Context) -> SimpleEntry {
		SimpleEntry(
			date: Date(),
			streak: data.progress(),
			configuration: StreakConfigIntent()
		)
	}
	
	func snapshot(for configuration: StreakConfigIntent, in context: Context) async ->  SimpleEntry {
		SimpleEntry(
			date: Date(),
			streak: data.progress(),
			configuration: configuration
		)
	}
	func timeline(for configuration: StreakConfigIntent, in context: Context) async -> Timeline<SimpleEntry> {
		var entries: [SimpleEntry] = []
		
		// Generate a timeline consisting of five entries an hour apart, starting from the current date.
		let currentDate = Date()
		for hourOffset in 0 ..< 5 {
			let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
			let entry = SimpleEntry(date: entryDate, streak: data.progress(), configuration: configuration)
			entries.append(entry)
		}
		
		return Timeline(
			entries: entries,
			policy:.after(Calendar.current
				.date(byAdding: .minute,
					  value: 5,
					  to: Date())!))
	}
	
}

struct SimpleEntry: TimelineEntry {
	let date: Date
	let streak: Int
	let configuration: StreakConfigIntent
}


/// Widget View
struct widgetextensionEntryView : View {
	var entry: Provider.Entry
	
	@Environment(\.widgetFamily) var family
	let data = DataService()
	
	var body: some View {
		if family == .systemSmall {
			smallWidgetView
		} else if family == .systemMedium {
			mediumWidgetView
		} else {
			smallWidgetView
		}
	}
	/// small
	var smallWidgetView: some View {
		VStack {
			ZStack {
				Circle()
					.stroke(.white.opacity(0.1), lineWidth: 15)
				
				let targetStreak = entry.configuration.targetStreak
				let pct = min(1.0, Double(data.progress()) / Double(targetStreak))
				
				let progressColor: Color = {
					switch entry.configuration.progressColor {
					case .blue: return .blue
					case .red: return .red
					case .purple: return .purple
					case .orange: return .orange
					default: return .blue
					}
				}()
				
				
				Circle()
					.trim(from: 0, to: pct)
					.stroke(
						progressColor.opacity(1),
						style: StrokeStyle(
							lineWidth: 15,
							lineCap: .round,
							lineJoin: .round
						)
					)
					.rotationEffect(.degrees(-90))
				
				VStack {
					if data.isGoalReached(target: targetStreak) {
						Text("🎉 목표달성")
							.font(.caption)
							.foregroundStyle(.green)
							.padding(.bottom, 2)
					}
					
					Text(String(data.progress()))
						.font(.title)
						.contentTransition(.numericText())
				}
				.foregroundStyle(.white)
				.fontDesign(.rounded)
				
			}
			
			VStack {
				if data.isGoalReached(target: entry.configuration.targetStreak) {
					Text("목표 완료")
						.padding(.horizontal)
						.foregroundStyle(.gray)
				} else {
					Button(intent: LogEntry()) {
						Text("+1")
							.padding(.horizontal)
					}
				}
			}
		}
		.containerBackground(.black, for: .widget)
	}
	/// medium
	var mediumWidgetView: some View {
		HStack {
			// 왼쪽: 원형 그래프
			ZStack {
				Circle()
					.stroke(.white.opacity(0.1), lineWidth: 15)
				
				let targetStreak = entry.configuration.targetStreak
				let pct = min(1.0, Double(data.progress()) / Double(targetStreak))
				
				let progressColor: Color = {
					switch entry.configuration.progressColor {
					case .green: return .green
					case .red: return .red
					case .purple: return .purple
					case .orange: return .orange
					default: return .blue
					}
				}()
				
				Circle()
					.trim(from: 0, to: pct)
					.stroke(
						progressColor.opacity(1),
						style: StrokeStyle(
							lineWidth: 15,
							lineCap: .round,
							lineJoin: .round
						)
					)
					.rotationEffect(.degrees(-90))
				
				VStack {
					if data.isGoalReached(target: targetStreak) {
						Text("🎉 목표달성")
							.font(.caption)
							.foregroundStyle(.green)
							.padding(.bottom, 2)
					}
					
					Text(String(data.progress()))
						.font(.title)
						.contentTransition(.numericText())
				}
				.foregroundStyle(.white)
				.fontDesign(.rounded)
			}
			.frame(width: 110, height: 110)
			.padding(.leading, 8)
			
			Spacer()
				.frame(maxWidth: 32)
			
			// 오른쪽: 버튼들을 상단과 하단에 배치
			VStack(spacing: 16) {
				// 상단에 +1 버튼 (목표 달성 시 비활성화)
				if data.isGoalReached(target: entry.configuration.targetStreak) {
					Text("목표 완료")
						.font(.title)
						.foregroundColor(.gray)
						.padding(.top, 10)
				} else {
					Button(intent: LogEntry()) {
						ZStack {
							// 수동으로 배경 만들기
							Capsule()
								.fill(Color.blue)
								.frame(height: 36)
								.frame(minWidth: 80)
							
							// 텍스트와 아이콘
							HStack(spacing: 4) {
								Image(systemName: "plus.circle.fill")
								Text("+1")
							}
							.font(.body)
							.fontWeight(.semibold)
							.foregroundColor(.white)
						}
					}
					.buttonStyle(PlainButtonStyle())
					.padding(.top, 8)
					// 기본 버튼 스타일
					//					Button(intent: LogEntry()) {
					//						Label("+1", systemImage: "plus.circle.fill")
					//							.font(.body)
					//							.fontWeight(.semibold)
					//							.foregroundColor(.white)
					//							.padding(.vertical, 8)
					//							.padding(.horizontal, 12)
					//							.background(
					//								Capsule()
					//									.fill(Color.blue)
					//							)
					//					}
					//					.padding(.top, 10)
				}
				
				Spacer()
				
				// 항상 표시되는 Reset 버튼
				Button(intent: ResetStreakIntent()) {
					ZStack {
						// 수동으로 배경 만들기
						Capsule()
							.fill(Color.red)
							.frame(height: 36)
							.frame(minWidth: 80)
						
						// 텍스트와 아이콘
						HStack(spacing: 4) {
							Image(systemName: "arrow.counterclockwise.circle.fill")
							Text("Reset")
						}
						.font(.body)
						.fontWeight(.semibold)
						.foregroundColor(.white)
					}
				}
				.buttonStyle(PlainButtonStyle()) // 기본 버튼 스타일 제거
				.padding(.bottom, 8)
			}
			.padding(.trailing, 32)
		}
		.containerBackground(.black, for: .widget)
	}
}



struct widgetextension: Widget {
	/// identifier
	let kind: String = "widgetextension"
	
	var body: some WidgetConfiguration {
		/// Dynamic - widget Configuration
		AppIntentConfiguration(
			kind: kind,
			intent: StreakConfigIntent.self,
			provider: Provider()) { entry in
				if #available(iOS 17.0, *) {
					widgetextensionEntryView(entry: entry)
				} else {
					widgetextensionEntryView(entry: entry)
						.padding()
						.background()
				}
			}
			.configurationDisplayName("Streak Widget")
			.description("Track the number increasing in real-time")
			.supportedFamilies([.systemSmall, .systemMedium])
		
		
		/// the actual view of widget
		
		
	}
}
#Preview(as: .systemSmall) {
	widgetextension()
} timeline: {
	SimpleEntry(date: .now, streak: 1, configuration: StreakConfigIntent())
	SimpleEntry(date: .now, streak: 4, configuration: StreakConfigIntent())
	
}
