//
//  ShortcutDemoApp.swift
//  ShortcutDemo
//
//  Created by Seohyun Kim on 14/10/2023
//

import SwiftUI
import Intents

@main
struct ShortcutDemoApp: App {
	
	@Environment(\.scenePhase) private var scenePhase
	
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
		  .onChange(of: scenePhase) { phase in
			  INPreferences.requestSiriAuthorization { status in
				  // the handling of Status
			  }
		  }
    }
}
