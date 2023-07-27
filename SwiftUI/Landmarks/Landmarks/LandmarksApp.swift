//
//  LandmarksApp.swift
//  Landmarks
//
//  Created by Seohyun Kim on 2023/07/25.
//

import SwiftUI

@main
struct LandmarksApp: App {
	@State private var modelData = ModelData()
	
    var body: some Scene {
        WindowGroup {
            ContentView()
				.environmentObject(modelData)
        }
    }
}
