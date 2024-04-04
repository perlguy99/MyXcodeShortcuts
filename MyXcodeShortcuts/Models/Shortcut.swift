//
//  Shortcut.swift
//  MyXcodeFaves
//
//  Created by Brent Michalski on 3/13/24.
//

import Foundation
import SwiftData

@Model
class Shortcut: Codable {
    enum CodingKeys: CodingKey {
        case keyCombo, details, buttonState, category
    }
    
    var keyCombo: String = ""
    var details: String = ""
    weak var category: Category?
    var buttonState: CheckboxState
    
    init(keyCombo: String, details: String, buttonState: CheckboxState = CheckboxState.none, category: Category? = nil) {
        self.keyCombo = keyCombo
        self.details = details
        self.buttonState = buttonState
        
        if let category = category {
            self.category = category
        }
    }
    
    func isFavorite() -> Bool {
        return buttonState == .favorite
    }
    
    func isHidden() -> Bool {
        return buttonState == .hidden
    }
    
    // Conform to Codable
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        keyCombo = try values.decodeIfPresent(String.self, forKey: .keyCombo) ?? ""
        details = try values.decodeIfPresent(String.self, forKey: .details) ?? ""
        buttonState = try values.decodeIfPresent(CheckboxState.self, forKey: .buttonState) ?? .none
        category = try values.decodeIfPresent(Category.self, forKey: .category)
    }
    
    // Conform to Codable
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(keyCombo, forKey: .keyCombo)
        try container.encode(details, forKey: .details)
        try container.encode(buttonState, forKey: .buttonState)
    }
    
//    var filteredShortcuts: [Shortcut] = {
//        
//    }()
    
//    let filteredCount = startingShortcuts.filter { shortcut in
//        print("Filtering on: \(filterOn)")
//        print("Current state: \(shortcut.buttonState)")
//        
//        if filterOn == .none {
//            return true
//        }
//        
//        if filterOn == .favorite {
//            if shortcut.buttonState == .favorite {
//                return true
//            }
//        }
//        
//        if filterOn == .hidden {
//            if shortcut.buttonState == .hidden {
//                return true
//            }
//        }
//            
//        return false
//    }
}


class ShortcutX: Codable {
    enum CodingKeys: CodingKey {
        case keyCombo, details
    }
    
    var keyCombo: String = ""
    var details: String = ""
    weak var category: CategoryX?
    
    init(keyCombo: String, details: String, category: CategoryX? = nil) {
        self.keyCombo = keyCombo
        self.details = details
        
        if let category = category {
            self.category = category
        }
    }
    
    // Conform to Codable
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        keyCombo = try values.decodeIfPresent(String.self, forKey: .keyCombo) ?? ""
        details = try values.decodeIfPresent(String.self, forKey: .details) ?? ""
    }
    
    // Conform to Codable
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(keyCombo, forKey: .keyCombo)
    }
}
