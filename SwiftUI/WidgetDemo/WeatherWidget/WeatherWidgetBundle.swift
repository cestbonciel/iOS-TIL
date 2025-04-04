//
//  WeatherWidgetBundle.swift
//  WeatherWidget
//
//  Created by Nat Kim on 4/4/25.
//

import WidgetKit
import SwiftUI

@main
struct WeatherWidgetBundle: WidgetBundle {
    var body: some Widget {
        WeatherWidget()
        WeatherWidgetControl()
        WeatherWidgetLiveActivity()
    }
}
