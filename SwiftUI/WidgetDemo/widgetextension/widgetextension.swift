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

//	func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
//		let entry = SimpleEntry(date: Date(), streak: data.progress())
//		completion(entry)
//	}
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
		
		return Timeline(entries: entries, policy: .atEnd)
	}
//	func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
//		var entries: [SimpleEntry] = []
//
//		// Generate a timeline consisting of five entries an hour apart, starting from the current date.
//		let currentDate = Date()
//		for hourOffset in 0 ..< 5 {
//			let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
//			let entry = SimpleEntry(date: entryDate, streak: data.progress())
//			entries.append(entry)
//		}
//
//		let timeline = Timeline(entries: entries, policy: .atEnd)
//		completion(timeline)
//	}

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
	let date: Date
	let streak: Int
	let configuration: StreakConfigIntent
}


/// Widget View
struct widgetextensionEntryView : View {
	var entry: Provider.Entry
	
	let data = DataService()
	
	var body: some View {
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
			.supportedFamilies([.systemSmall])
		
		
		/// the actual view of widget
//		StaticConfiguration(kind: kind, provider: Provider()) { entry in
//			if #available(iOS 17.0, *) {
//				widgetextensionEntryView(entry: entry)
//					
//			} else {
//				widgetextensionEntryView(entry: entry)
//					.padding()
//					.background()
//			}
//		}
//		.configurationDisplayName("widgetextension")
//		.description("This is an example widget.")
//		.supportedFamilies([.systemSmall])
		
		
		
	}
}
#Preview(as: .systemSmall) {
	widgetextension()
} timeline: {
	SimpleEntry(date: .now, streak: 1, configuration: StreakConfigIntent())
	SimpleEntry(date: .now, streak: 4, configuration: StreakConfigIntent())
	
}
