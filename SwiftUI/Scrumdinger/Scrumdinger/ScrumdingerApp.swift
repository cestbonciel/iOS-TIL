//
//  ScrumdingerApp.swift
//  Scrumdinger
//
//  Created by Seohyun Kim on 2023/07/23.
//

import SwiftUI

@main
struct ScrumdingerApp: App {
	@State private var scrums = DailyScrum.sampleData
	
    var body: some Scene {
        WindowGroup {
			ScrumsView(scrums: $scrums)
        }
    }
}
