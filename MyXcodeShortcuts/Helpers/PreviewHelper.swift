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
    var previewShortcut: Shortcut = Shortcut(keyCombo: "cmd opt %", details: "Preview Details 1B", status: .none)
    var previewShortcutWithCategory: Shortcut = Shortcut(keyCombo: "cmd ctrl opt F", details: "Preview Details X F", status: .none)
    var previewShortcutWithCategoryHidden: Shortcut = Shortcut(keyCombo: "ctrl opt H", details: "Hide something", status: .hidden)

    var previewNone = Shortcut(keyCombo: "cmd opt N", details: "Status None", status: .none)
    var previewFavorite = Shortcut(keyCombo: "opt shift H", details: "Status Favorite", status: .favorite)
    var previewHidden = Shortcut(keyCombo: "cmd ctrl opt shift W", details: "Status Hidden", status: .hidden)

    
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
    
    // If a container is passed in, use it. Otherwise, use sharedModelContainer
    init(container: ModelContainer? = nil) {
        guard let container = container else {
            self.container = sharedModelContainer
            return
        }
        
        self.container = container
    }
    
    func loadSeedData(skipDataCheck: Bool = false) {
        let seed = SeedData(modelContext: container.mainContext)
        seed.loadSeedData()
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
