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
    var previewCategory: Category
    var previewShortcut: Shortcut
    var previewShortcutWithCategory: Shortcut
    var previewShortcutWithCategoryHidden: Shortcut

    var previewNone: Shortcut
    var previewFavorite: Shortcut
    var previewHidden: Shortcut

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Category.self,
            Shortcut.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    init() {
//        let schema = Schema([
//            Category.self,
//            Shortcut.self
//        ])
//        
//        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        
//        container = try ModelContainer(for: Category.self, configurations: config)
        container = sharedModelContainer
        
        previewCategory = Category(name: "Preview Menu Category B")
        previewShortcut = Shortcut(keyCombo: "Cmd Opt %", details: "Preview Details 1B", buttonState: .none)
        
        container.mainContext.insert(previewCategory)
        
        previewShortcutWithCategory = Shortcut(keyCombo: "Cmd Ctrl opt F", details: "Preview Details X F", buttonState: .none, category: previewCategory)
        previewShortcutWithCategoryHidden = Shortcut(keyCombo: "Ctrl opt H", details: "Hide something", buttonState: .hidden, category: previewCategory)
        
        previewNone = Shortcut(keyCombo: "Cmd opt N", details: "Status None", buttonState: .none, category: previewCategory)
        previewFavorite = Shortcut(keyCombo: "opt shift H", details: "Status Favorite", buttonState: .favorite, category: previewCategory)
        previewHidden = Shortcut(keyCombo: "Cmd ctrl opt shift W", details: "Status Hidden", buttonState: .hidden, category: previewCategory)

        previewCategory.shortcuts.append(previewShortcutWithCategory)
        previewCategory.shortcuts.append(previewShortcutWithCategoryHidden)
        previewCategory.shortcuts.append(previewShortcut)
        
        previewCategory.shortcuts.append(previewNone)
        previewCategory.shortcuts.append(previewFavorite)
        previewCategory.shortcuts.append(previewHidden)
    }

    func deleteAll() {
        print("\n------------------------------")
        print("DELETING ALL DATA")
        print("------------------------------\n")
        
        do {
            try container.mainContext.delete(model: Category.self)
            try container.mainContext.delete(model: Shortcut.self)
        } catch {
            print("Failed to empty the database\n\(error.localizedDescription)")
        }
    }

}
