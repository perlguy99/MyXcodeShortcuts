//
//  PreviewHelper.swift
//  MyXcodeShortcuts
//
//  Created by Brent Michalski on 4/1/24.
//

import Foundation
import SwiftData

@MainActor
struct PreviewHelper {
    let container: ModelContainer
    var previewCategory: Category = Category(name: "Preview Menu Category B")
    var previewShortcut: Shortcut = Shortcut(keyCombo: "Cmd Opt %", details: "Preview Details 1B", buttonState: .none)
    var previewShortcutWithCategory: Shortcut = Shortcut(keyCombo: "Cmd Ctrl opt F", details: "Preview Details X F", buttonState: .none)
    var previewShortcutWithCategoryHidden: Shortcut = Shortcut(keyCombo: "Ctrl opt H", details: "Hide something", buttonState: .hidden)

    var previewNone = Shortcut(keyCombo: "Cmd opt N", details: "Status None", buttonState: .none)
    var previewFavorite = Shortcut(keyCombo: "opt shift H", details: "Status Favorite", buttonState: .favorite)
    var previewHidden = Shortcut(keyCombo: "Cmd ctrl opt shift W", details: "Status Hidden", buttonState: .hidden)

    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([Category.self, Shortcut.self])
        
        #if targetEnvironment(simulator)
        let isStoredInMemoryOnly = true
        #else
        let isStoredInMemoryOnly = false
        #endif
        
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    init() {
        container = sharedModelContainer
    }
    
    func loadSeedData(skipDataCheck: Bool = false) {
        let seed = SeedData(modelContext: container.mainContext)
        seed.loadSeedData(skipDataCheck: skipDataCheck)
    }
    
    func loadSampleData() {
        
        // Insert the first category
        container.mainContext.insert(previewCategory)
        
        previewCategory.shortcuts.append(previewShortcutWithCategory)
        previewCategory.shortcuts.append(previewShortcutWithCategoryHidden)
        previewCategory.shortcuts.append(previewShortcut)
        
        previewCategory.shortcuts.append(previewNone)
        previewCategory.shortcuts.append(previewFavorite)
        previewCategory.shortcuts.append(previewHidden)
    }
    
}
