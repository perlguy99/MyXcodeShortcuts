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
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    @MainActor
    func loadSeedData() {
        guard let path = Bundle.main.path(forResource: "SeedData", ofType: "json") else {
            print("Error! - Failed to locate SeedData.json in bundle.")
            return
        }
        
        do {
            let url = URL(fileURLWithPath: path)
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            
            let categories = try decoder.decode(CategoriesX.self, from: data)
            
            for category in categories.categories {
                let currentCategory = Category(name: category.name)
                modelContext.container.mainContext.insert(currentCategory)
                
                guard let shortcuts = category.shortcuts else { continue }
                
                if shortcuts.isNotEmpty {
                    for shortcut in shortcuts {
                        shortcut.category = category
                        print(shortcut.keyCombo)
                        
                        let currentShortcut = Shortcut(keyCombo: shortcut.keyCombo, details: shortcut.details, buttonState: .none, category: currentCategory)
                        currentCategory.shortcuts?.append(currentShortcut)
                    }
                }
                
                seedData.append(currentCategory)
            }
        } catch {
            print("\n------------------------------")
            print(error.localizedDescription)
            print("------------------------------\n")
        }
        
    }
    
    
    @MainActor
    func loadSeedData2() {
        guard let path = Bundle.main.path(forResource: "SeedData", ofType: "json") else {
            print("Error! - Failed to locate SeedData.json in bundle.")
            return
        }
        
        do {
            let url = URL(fileURLWithPath: path)
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            
            let categories = try decoder.decode(Categories.self, from: data)
            
            for category in categories.categories {
                let currentCategory = Category(name: category.name)
                modelContext.container.mainContext.insert(currentCategory)
                
                guard let shortcuts = category.shortcuts else { continue }
                
                if shortcuts.isNotEmpty {
                    for shortcut in shortcuts {
                        shortcut.category = category
                        print(shortcut.keyCombo)
                        
                        let currentShortcut = Shortcut(keyCombo: shortcut.keyCombo, details: shortcut.details, buttonState: .none, category: currentCategory)
                        currentCategory.shortcuts?.append(currentShortcut)
                    }
                }
                
                seedData.append(currentCategory)
            }
        } catch {
            print("\n------------------------------")
            print(error.localizedDescription)
            print("------------------------------\n")
        }
        
    }
    
    
}
