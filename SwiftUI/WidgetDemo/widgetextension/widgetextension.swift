//
//  widgetextension.swift
//  widgetextension
//
//  Created by Nat Kim on 5/18/25.
//

import WidgetKit
import SwiftUI

/// Provider: the supplier of the data
struct Provider: TimelineProvider {
	let data = DataService()
	
	func placeholder(in context: Context) -> SimpleEntry {
		SimpleEntry(date: Date(), streak: data.progress())
	}

	func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
		let entry = SimpleEntry(date: Date(), streak: data.progress())
		completion(entry)
	}

	func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
		var entries: [SimpleEntry] = []

		// Generate a timeline consisting of five entries an hour apart, starting from the current date.
		let currentDate = Date()
		for hourOffset in 0 ..< 5 {
			let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
			let entry = SimpleEntry(date: entryDate, streak: data.progress())
			entries.append(entry)
		}

		let timeline = Timeline(entries: entries, policy: .atEnd)
		completion(timeline)
	}

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
	let date: Date
	let streak: Int
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
				
				let pct = Double(data.progress())/50.0
				
				Circle()
					.trim(from: 0, to: pct)
					.stroke(
						.blue.opacity(1),
						style: StrokeStyle(
							lineWidth: 15,
							lineCap: .round,
							lineJoin: .round
						)
					)
					.rotationEffect(.degrees(-90))
				
				VStack {
					Text(String(data.progress()))
						.font(.title)
						.contentTransition(.numericText())
				}
				.foregroundStyle(.white)
				.fontDesign(.rounded)
				
				
			}
			Button(intent: LogEntry()) {
				Text("+1")
					.padding(.horizontal)
			}
			
		}
		
		.containerBackground(.black, for: .widget)
	}
}


struct widgetextension: Widget {
	/// identifier
	let kind: String = "widgetextension"
	
	var body: some WidgetConfiguration {
		
		/// the actual view of widget
		StaticConfiguration(kind: kind, provider: Provider()) { entry in
			if #available(iOS 17.0, *) {
				widgetextensionEntryView(entry: entry)
					
			} else {
				widgetextensionEntryView(entry: entry)
					.padding()
					.background()
			}
		}
		.configurationDisplayName("widgetextension")
		.description("This is an example widget.")
		.supportedFamilies([.systemSmall])
	}
}
#Preview(as: .systemSmall) {
	widgetextension()
} timeline: {
	SimpleEntry(date: .now, streak: 1)
	SimpleEntry(date: .now, streak: 4)
	
}
