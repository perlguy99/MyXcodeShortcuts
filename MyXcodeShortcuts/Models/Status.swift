//
//  Status.swift
//  MyXcodeShortcuts
//
//  Created by Brent Michalski on 4/1/24.
//

import Foundation
import SwiftUI

enum Status: Int, Codable {
    case none = 0
    case favorite = 1
    case hidden = 2
    
    // Initialize with Int
    init(rawValue: Int) {
        switch rawValue {
        case 1:
            self = .favorite
        case 2:
            self = .hidden
        default:
            self = .none
        }
    }
    
    var color: Color {
        switch self {
        case .none:
            return Color.blue
        case .favorite:
            return Color.yellow
        case .hidden:
            return Color.red
        }
    }
    
    mutating func toggle() {
        switch self {
        case .none:
            self = .favorite
        case .favorite:
            self = .hidden
        case .hidden:
            self = .none
        }
    }
    
    var stringValue: String {
        switch self {
        case .none:
            return "none"
        case .favorite:
            return "favorite"
        case .hidden:
            return "hidden"
        }
    }

    var headingValue: String {
        switch self {
        case .none:
            return "Showing All but Hidden"
        case .favorite:
            return "Showing Favorites Only"
        case .hidden:
            return "Showing Hidden"
        }
    }

    // Convert to Int
    var intValue: Int {
        return self.rawValue
    }
}

