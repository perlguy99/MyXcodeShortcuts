//
//  SeedData.swift
//  MyXcodeShortcuts
//
//  Created by Brent Michalski on 4/3/24.
//

import Foundation
import SwiftData

class SeedData {
    var modelContext: ModelContext
    var seedData: [Category] = [Category]()
    var skipDataCheck: Bool = false
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    @MainActor
    func loadSeedData(_ filename: String? = "SeedData_Release_1") {
        guard let path = Bundle.main.path(forResource: filename, ofType: "json") else {
            print("Error! - Failed to locate SeedData.json in bundle.")
            return
        }
        
        let fetchDescriptor = FetchDescriptor<Category>()
        
        do {
            if skipDataCheck == false {
                let dataCheck = try modelContext.fetch(fetchDescriptor)
                
                // if not empty, we don't want to load the data again
                if dataCheck.isNotEmpty {
                    return
                }
            }
            
            let url = URL(fileURLWithPath: path)
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            
            let categories = try decoder.decode(CategoriesX.self, from: data)

            let shortcutApp = ShortcutApp(name: "Xcode Shortcuts")
            modelContext.insert(shortcutApp)

            for (categoryIndex, category) in categories.categories.enumerated() {
                let currentCategory = Category(name: category.name, order: categoryIndex)
                currentCategory.shortcutApp = shortcutApp
                modelContext.insert(currentCategory)

                guard let shortcuts = category.shortcuts else { continue }

                if shortcuts.isNotEmpty {
                    for (shortcutIndex, shortcut) in shortcuts.enumerated() {
                        shortcut.category = category

                        let currentShortcut = Shortcut(keyCombo: shortcut.keyCombo, details: shortcut.details, status: .none, category: currentCategory, order: shortcutIndex)
                        currentCategory.shortcuts.append(currentShortcut)
                    }
                }

                seedData.append(currentCategory)
            }

            try modelContext.save()
        } catch {
            print("\n------------------------------")
            print(error.localizedDescription)
            print("------------------------------\n")
        }
    }
}
