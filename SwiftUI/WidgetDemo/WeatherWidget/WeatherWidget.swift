//
//  WeatherWidget.swift
//  WeatherWidget
//
//  Created by Nat Kim on 4/4/25.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> WeatherEntry {
        WeatherEntry(
            date: Date(),
            city: "London",
            temperature: 89,
            description: "Thunder Storm",
            icon: "cloud.bolt.rain",
            image: "thunder",
            url: thunderUrl
        )
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> WeatherEntry {
        let entry = WeatherEntry(
            date: Date(),
            city: "London",
            temperature: 89,
            description: "Thunder Storm",
            icon: "cloud.bolt.rain",
            image: "thunder",
            url: thunderUrl
        )
        return entry
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<WeatherEntry> {
        var entries: [WeatherEntry] = []
        var eventDate = Date()
        let halfMinute: TimeInterval = 30
        
        for var entry in londonTimeline {
            entry.date = eventDate
            eventDate += halfMinute
            entries.append(entry)
        }
        let timeline = Timeline(entries: entries, policy: .never)
        return timeline
    }
}


struct WeatherWidgetEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var widgetFamily
    
    var body: some View {
        ZStack {
            Color("weatherBackgroundColor")
            
            HStack {
                WeatherSubView(entry: entry)
                if widgetFamily == .systemMedium {
                    Image(entry.image)
                        .resizable()
                }
            }
                
        }
        //.containerBackground(.fill.tertiary, for: .widget)
        .widgetURL(entry.url)
    }
}

struct WeatherSubView: View {
    var entry: WeatherEntry
    
    var body: some View {
        VStack {
            VStack {
                Text("\(entry.city)")
                    .font(.title)
                Image(systemName: entry.icon)
                    .font(.largeTitle)
                Text("\(entry.description)")
                    .frame(minWidth: 125, minHeight: nil)
            }
            .padding(.bottom, 20)
            .background(ContainerRelativeShape().fill(Color("weatherInsetColor")))
            
            Label("\(entry.temperature)°F", systemImage: "thermometer")
        }
        .foregroundStyle(.white)
        .padding()
    }

}

struct WeatherWidget: Widget {
    let kind: String = "WeatherWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: ConfigurationAppIntent.self,
            provider: Provider()
        ) { entry in
            WeatherWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("My Weather Widget")
        .description("A demo Weather Widget")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

// MARK: - useless default dummy data
/*
extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}
*/


#Preview(
"Thunder Storm",
 as: .systemSmall,
 widget: {
    WeatherWidget()
},
 timeline: {
    WeatherEntry(
        date: Date(),
        city: "London",
        temperature: 89,
        description: "Thunder Storm",
        icon: "cloud.bolt.rain",
        image: "thunder", url: thunderUrl
    )
})

#Preview(
  "Medium 크기",
  as: .systemMedium,
  widget: {
    WeatherWidget()
  },
  timeline: {
    WeatherEntry(
      date: Date(),
      city: "London",
      temperature: 89,
      description: "Thunder Storm",
      icon: "cloud.bolt.rain.fill",
      image: "thunder", url: thunderUrl
    )
  }
)

#Preview(
  "Large 크기",
  as: .systemLarge,
  widget: {
    WeatherWidget()
  },
  timeline: {
    WeatherEntry(
      date: Date(),
      city: "London",
      temperature: 89,
      description: "Thunder Storm",
      icon: "cloud.bolt.rain.fill",
      image: "thunder", url: thunderUrl
    )
  }
)

