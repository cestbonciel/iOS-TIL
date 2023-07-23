//
//  ScrumdingerApp.swift
//  Scrumdinger
//
//  Created by Seohyun Kim on 2023/07/23.
//

import SwiftUI

@main
struct ScrumdingerApp: App {
    var body: some Scene {
        WindowGroup {
			ScrumsView(scrums: DailyScrum.sampleData)
        }
    }
}
