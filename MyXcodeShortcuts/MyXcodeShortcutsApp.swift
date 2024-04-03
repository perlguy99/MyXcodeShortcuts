//
//  MyXcodeShortcutsApp.swift
//  MyXcodeShortcuts
//
//  Created by Brent Michalski on 4/1/24.
//

import SwiftUI
import SwiftData

@main
struct MyXcodeShortcutsApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([Category.self])
        
        #if targetEnvironment(simulator)
        let isStoredInMemoryOnly = true
        #else
        let isStoredInMemoryOnly = false
        #endif
        
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: isStoredInMemoryOnly)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
