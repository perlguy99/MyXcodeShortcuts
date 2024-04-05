//
//  Category.swift
//  MyXcodeFaves
//
//  Created by Brent Michalski on 3/13/24.
//

import Foundation
import SwiftData

@Model
class Category: Codable {
    
    enum CodingKeys: CodingKey {
        case name, shortcuts
    }
    
    var name: String = ""
    @Relationship(deleteRule: .cascade, inverse: \Shortcut.category) var shortcuts: [Shortcut]? = [Shortcut]()
    
    init(name: String) {
        self.name = name
    }
    
    // Conform to Codable
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        
        self.shortcuts = try container.decode([Shortcut].self, forKey: .shortcuts)
    }
    
    // Conform to Codable
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(shortcuts, forKey: .shortcuts)
    }
}

extension Category {
    static let mock: Category = .init(name: "Mock Category")
}

extension Category {
    
//    func filteredShortcuts(filterValue: CheckboxState = .none) -> [Shortcut]? {
    func filteredShortcuts(filterValue: SharedCheckboxState) -> [Shortcut]? {
        print("Filtering on: \(filterValue.state)")
        
        let filtered = shortcuts?.filter({ shortcut in
            print("Current state: \(shortcut.buttonState)")
            
            if filterValue.state == .none {
                return true
            }
            
            if filterValue.state == .favorite {
                if shortcut.buttonState == .favorite {
                    return true
                }
            }
            
            if filterValue.state == .hidden {
                if shortcut.buttonState != .hidden {
                    return true
                }
            }
            
            return false
        })
        
        return filtered
    }
    
}


struct MenuShortcuts: Codable {
    let categories: [Category]
}


class CategoryX: Codable {
    enum CodingKeys: CodingKey {
        case name, shortcuts
    }
    
    var name: String = ""
    var shortcuts: [ShortcutX]? = [ShortcutX]()
    
    init(name: String) {
        self.name = name
    }
    
    // Conform to Codable
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        
        self.shortcuts = try container.decode([ShortcutX].self, forKey: .shortcuts)
    }
    
    // Conform to Codable
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(shortcuts, forKey: .shortcuts)
    }
}
