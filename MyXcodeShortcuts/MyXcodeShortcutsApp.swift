//
//  MyXcodeShortcutsApp.swift
//  MyXcodeShortcuts
//
//  Created by Brent Michalski on 4/1/24.
//

import SwiftUI
import SwiftData

//@AppStorage(Constants.Keys.pdfTitle.stringValue) var pdfTitle = Constants.defaultTitle
//@AppStorage(Constants.Keys.separator.rawValue) var separator = Constants.defaultSeparator
//@AppStorage(Constants.Keys.showSymbols.rawValue) var showSymbols: Bool = true

// TODO: Tests?
// TODO: Automatically keeping the order of keys in shortcuts consistent
// TODO: Sorting on shortcuts
// TODO: I've got all of the Xcode shortcuts from the Apple Documentation, but there are more to be added.

@main
@MainActor
struct MyXcodeShortcutsApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([Category.self, Shortcut.self])
        
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
    
    func checkSeed() {
        let seed = SeedData(modelContext: sharedModelContainer.mainContext)
        seed.loadSeedData()
    }
    
    var body: some Scene {
        let _ = checkSeed()
        
        WindowGroup {
            return ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
