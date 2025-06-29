//
//  widgetextension.swift
//  widgetextension
//
//  Created by Nat Kim on 6/23/25.
//

import WidgetKit
import SwiftUI

struct CoffeeTimelineProvider: TimelineProvider {
	func placeholder(in context: Context) -> CoffeeEntry {
		CoffeeEntry(
			date: Date(),
			totalCaffeine: 125,
			lastCoffee: CoffeeRecord(id: UUID(), name: "아메리카노", caffeine: 125, timestamp: Date()),
			recentEntries: []
		)
	}

    func getSnapshot(in context: Context, completion: @escaping (CoffeeEntry) -> ()) {
		let entry = loadCurrentData()
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
		let currentEntry = loadCurrentData()
		
		let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date()
		
		let timeline = Timeline(entries: [currentEntry], policy: .after(nextUpdate))
		
		completion(timeline)
    }
	
	private func loadCurrentData() -> CoffeeEntry {
		guard let userDefaults = UserDefaults(suiteName: "group.com.seohyunKim.iOS.CoffeePushWidget2025"),
			  let data = userDefaults.data(forKey: "coffeeEntries"),
			  let entries = try? JSONDecoder().decode([CoffeeRecord].self, from: data) else {
			return CoffeeEntry(
				date: Date(),
				totalCaffeine: 0,
				lastCoffee: nil,
				recentEntries: []
			)
		}
		
		// 오늘 데이터 필터링
		let today = Calendar.current.startOfDay(for: Date())
		let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
		
		let todayEntries = entries.filter { entry in
			entry.timestamp >= today && entry.timestamp < tomorrow
		}
		
		let totalCaffeine = todayEntries.reduce(0) { $0 + $1.caffeine }
		let lastCoffee = todayEntries.first
		
		return CoffeeEntry(
			date: Date(),
			totalCaffeine: totalCaffeine,
			lastCoffee: lastCoffee,
			recentEntries: Array(todayEntries.prefix(3))
		)
	}

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}



struct widgetextensionEntryView : View {
    var entry: CoffeeTimelineProvider.Entry
	@Environment(\.widgetFamily) var family
	
	var body: some View {
		switch family {
		case .systemSmall:
			SmallWidgetView(entry: entry)
		case .systemMedium:
			MediumWidgetView(entry: entry)
		default:
			SmallWidgetView(entry: entry)
		}
	}
}

struct SmallWidgetView: View {
	let entry: CoffeeEntry
	
	var body: some View {
		VStack(spacing: 8) {
			// 카페인 총량
			VStack(spacing: 2) {
				Text("오늘 카페인")
					.font(.caption2)
					.foregroundColor(.secondary)
				Text("\(entry.totalCaffeine)mg")
					.font(.title2)
					.fontWeight(.bold)
					.foregroundColor(.primary)
			}
			
			Divider()
			
			// 마지막 커피 정보
			if let lastCoffee = entry.lastCoffee {
				VStack(spacing: 2) {
					Text("마지막 음료")
						.font(.caption2)
						.foregroundColor(.secondary)
					Text(lastCoffee.name)
						.font(.caption)
						.fontWeight(.medium)
						.lineLimit(1)
					Text(timeAgoString(from: lastCoffee.timestamp))
						.font(.caption2)
						.foregroundColor(.secondary)
				}
			} else {
				VStack(spacing: 2) {
					Text("☕️")
						.font(.title2)
					Text("아직 기록 없음")
						.font(.caption2)
						.foregroundColor(.secondary)
				}
			}
		}
		.padding()
	}
	
	private func timeAgoString(from date: Date) -> String {
		let interval = Date().timeIntervalSince(date)
		let hours = Int(interval) / 3600
		let minutes = Int(interval) % 3600 / 60
		
		if hours > 0 {
			return "\(hours)시간 전"
		} else if minutes > 0 {
			return "\(minutes)분 전"
		} else {
			return "방금 전"
		}
	}
}

struct MediumWidgetView: View {
	let entry: CoffeeEntry
	
	var body: some View {
		HStack(spacing: 16) {
			// 왼쪽: 카페인 총량
			VStack(spacing: 4) {
				Text("오늘 카페인")
					.font(.caption)
					.foregroundColor(.secondary)
				Text("\(entry.totalCaffeine)")
					.font(.largeTitle)
					.fontWeight(.bold)
					.foregroundColor(.primary)
				Text("mg")
					.font(.caption)
					.foregroundColor(.secondary)
			}
			.frame(maxWidth: .infinity)
			
			Divider()
			
			// 오른쪽: 최근 기록
			VStack(alignment: .leading, spacing: 4) {
				Text("최근 기록")
					.font(.caption)
					.foregroundColor(.secondary)
					.frame(maxWidth: .infinity, alignment: .leading)
				
				if entry.recentEntries.isEmpty {
					Text("아직 기록이 없습니다")
						.font(.caption2)
						.foregroundColor(.secondary)
						.frame(maxWidth: .infinity, alignment: .center)
				} else {
					ForEach(Array(entry.recentEntries.enumerated()), id: \.offset) { index, record in
						HStack {
							Text(record.name)
								.font(.caption2)
								.lineLimit(1)
							Spacer()
							Text("\(record.caffeine)mg")
								.font(.caption2)
								.foregroundColor(.secondary)
						}
					}
				}
			}
			.frame(maxWidth: .infinity)
		}
		.padding()
	}
}


struct widgetextension: Widget {
    let kind: String = "widgetextension"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CoffeeTimelineProvider()) { entry in
            if #available(iOS 17.0, *) {
                widgetextensionEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                widgetextensionEntryView(entry: entry)
                    .padding()
                    .background()
            }
		}
		.configurationDisplayName("Coffee Tracker")
		.description("오늘의 카페인 섭취량을 확인하세요")
		.supportedFamilies([.systemSmall, .systemMedium])
    }
}

#Preview(as: .systemSmall) {
	widgetextension()
} timeline: {
	CoffeeEntry(
		date: Date(),
		totalCaffeine: 285,
		lastCoffee: CoffeeRecord(id: UUID(), name: "카페라떼", caffeine: 150, timestamp: Date().addingTimeInterval(-3600)),
		recentEntries: [
			CoffeeRecord(id: UUID(), name: "아메리카노", caffeine: 125, timestamp: Date().addingTimeInterval(-7200)),
			CoffeeRecord(id: UUID(), name: "에스프레소", caffeine: 75, timestamp: Date().addingTimeInterval(-5400)),
			CoffeeRecord(id: UUID(), name: "카페라떼", caffeine: 150, timestamp: Date().addingTimeInterval(-3600))
		]
	)
}

#Preview(as: .systemMedium) {
	widgetextension()
} timeline: {
	CoffeeEntry(
		date: Date(),
		totalCaffeine: 285,
		lastCoffee: CoffeeRecord(id: UUID(), name: "카페라떼", caffeine: 150, timestamp: Date().addingTimeInterval(-3600)),
		recentEntries: [
			CoffeeRecord(id: UUID(), name: "아메리카노", caffeine: 125, timestamp: Date().addingTimeInterval(-7200)),
			CoffeeRecord(id: UUID(), name: "에스프레소", caffeine: 75, timestamp: Date().addingTimeInterval(-5400)),
			CoffeeRecord(id: UUID(), name: "카페라떼", caffeine: 150, timestamp: Date().addingTimeInterval(-3600))
		]
	)
}
