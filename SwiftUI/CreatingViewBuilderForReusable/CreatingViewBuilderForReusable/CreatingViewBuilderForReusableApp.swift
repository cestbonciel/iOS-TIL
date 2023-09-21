//
//  CreatingViewBuilderForReusableApp.swift
//  CreatingViewBuilderForReusable
//
//  Created by Seohyun Kim on 2023/09/16.
//

import SwiftUI

@main
struct CreatingViewBuilderForReusableApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
