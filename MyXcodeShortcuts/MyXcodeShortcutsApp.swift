//
//  MyXcodeShortcutsApp.swift
//  MyXcodeShortcuts
//
//  Created by Brent Michalski on 4/1/24.
//

import SwiftUI
import SwiftData

@main
@MainActor
struct MyXcodeShortcutsApp: App {
    @StateObject var checkboxState = SharedCheckboxState()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([Category.self, Shortcut.self])
        
        #if targetEnvironment(simulator)
        let isStoredInMemoryOnly = true
        #else
        let isStoredInMemoryOnly = false
        #endif
        
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    // TODO: Remove
//    var sharedModelContainer2: ModelContainer = {
//        do {
//            let schema = Schema([Category.self, Shortcut.self])
//            let container = try ModelContainer(for: schema)
//            
//            var tempCat = Category(name: "tempCat_XYZ")
//            container.mainContext.insert(tempCat)
//            
//            var tempShort = Shortcut(keyCombo: "CMD X", details: "tempShort", buttonState: .none, category: tempCat)
////            tempCat.shortcuts?.append(tempShort)
//            
//            return container
//            
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }()

    func checkSeed() {
        let seed = SeedData(modelContext: sharedModelContainer.mainContext)
        seed.loadSeedData()
    }
    
    var body: some Scene {
        // Load our seed data if there is none
        let _ = checkSeed()
        
        WindowGroup {
            return ContentView()
        }
        .modelContainer(sharedModelContainer)
        .environmentObject(checkboxState)
    }
}
