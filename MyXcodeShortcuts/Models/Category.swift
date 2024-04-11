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
    @Relationship(deleteRule: .cascade, inverse: \Shortcut.category) var shortcuts: [Shortcut] = [Shortcut]()
    
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
