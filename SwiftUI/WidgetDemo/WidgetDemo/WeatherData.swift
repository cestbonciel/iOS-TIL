//
//  WeatherData.swift
//  WidgetDemo
//
//  Created by Nat Kim on 4/4/25.
//

import Foundation
import WidgetKit

struct WeatherEntry: TimelineEntry {
    var date: Date
    let city: String
    let temperature: Int
    let description: String
    let icon: String
    let image: String
    let url: URL?
}

let hailUrl = URL(string: "weatherwidget://hail")
let thunderUrl = URL(string: "weatherwidget://thunder")
let tropicalUrl = URL(string: "weatherwidget://tropical")

let londonTimeline = [
    WeatherEntry(
        date: Date(),
        city: "London",
        temperature: 87,
        description: "Hail Storm",
        icon: "cloud.hail",
        image: "hail", url: hailUrl
    ),
    WeatherEntry(
        date: Date(),
        city: "London",
        temperature: 92,
        description: "Thunder Storm",
        icon: "cloud.bolt.rain",
        image: "thunder", url: thunderUrl
    ),
    WeatherEntry(
        date: Date(),
        city: "London",
        temperature: 95,
        description: "Hail Storm",
        icon: "cloud.hail",
        image: "hail", url: hailUrl
    )
]

let miamiTimeline = [
    WeatherEntry(
        date: Date(),
        city: "Miami",
        temperature: 81,
        description: "Thunder Storm",
        icon: "cloud.bolt.rain",
        image: "thunder", url: thunderUrl
    ),
    WeatherEntry(
        date: Date(),
        city: "Miami",
        temperature: 74,
        description: "Tropical Storm",
        icon: "tropicalstorm",
        image: "tropical", url: tropicalUrl
    ),
    WeatherEntry(
        date: Date(),
        city: "Miami",
        temperature: 72,
        description: "Thunder Storm",
        icon: "cloud.bolt.rain",
        image: "thunder", url: thunderUrl
    )
]

struct LocationData: Identifiable {
    let city: String
    let timeline: [WeatherEntry]
    
    var id: String {
        city
    }
    
    static let london = LocationData(city: "London", timeline: londonTimeline)
    static let miami = LocationData(city: "miami", timeline: miamiTimeline)
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(city)
    }
}
