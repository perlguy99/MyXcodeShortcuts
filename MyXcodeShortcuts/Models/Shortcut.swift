//
//  Shortcut.swift
//  MyXcodeFaves
//
//  Created by Brent Michalski on 3/13/24.
//

import SwiftUI
import SwiftData

@Model
class Shortcut: Codable {
    enum CodingKeys: CodingKey {
        case keyCombo, details, status, category
    }
    
    var keyCombo: String = ""
    var details: String = ""
    weak var category: Category?
    var status: Status = Status.none
    
    var separator: String {
        UserDefaults.standard.string(forKey: Constants.Keys.separator) ?? Constants.defaultSeparator
    }

    var showSymbols: Bool {
        UserDefaults.standard.bool(forKey: Constants.Keys.showSymbols)
    }

    var convertedKeyCombo: String {
        return keyCombo.parseForControlCharacterMapping(separator: separator, returnType: showSymbols ? .symbol : .long)
    }
    
    init(keyCombo: String, details: String, status: Status = Status.none, category: Category? = nil) {
        self.keyCombo = keyCombo.localizedLowercase
        self.details = details
        self.status = status
        
        if let category = category {
            self.category = category
        }
    }
    
    // Conform to Codable
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        keyCombo = try values.decodeIfPresent(String.self, forKey: .keyCombo) ?? ""
        details = try values.decodeIfPresent(String.self, forKey: .details) ?? ""
        status = try values.decodeIfPresent(Status.self, forKey: .status) ?? Status.none
        category = try values.decodeIfPresent(Category.self, forKey: .category)
    }
    
    // Conform to Codable
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(keyCombo, forKey: .keyCombo)
        try container.encode(details, forKey: .details)
        try container.encode(status, forKey: .status)
    }
    
    func matchesStatus(_ currentStatusInt: Int) -> Bool {
        let currentStatus = Status(rawValue: currentStatusInt)
        
        switch currentStatus {
            case .none:
                // If the filter is set to .none, all shortcuts should be shown.
                return self.status != .hidden
            case .favorite:
                // If the filter is set to .favorite, only show favorites.
                return self.status == .favorite
            case .hidden:
                // If the filter is set to .hidden, exclude hidden shortcuts.
                return true
        }
    }

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
