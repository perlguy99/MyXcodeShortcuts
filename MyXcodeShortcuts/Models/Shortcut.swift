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
        case keyCombo, details, status, category
    }
    
    var keyCombo: String = ""
    var details: String = ""
    weak var category: Category?
    var status: Status = Status.none
    
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
