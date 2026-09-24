//
//  Extensions.swift
//  MyXcodeShortcuts
//
//  Created by Brent Michalski on 4/1/24.
//

import Foundation
import SwiftUI

extension Array {
    var isNotEmpty: Bool {
        return !isEmpty
    }
}

extension String {
    var isNotEmpty: Bool {
        return !isEmpty
    }
}

// TODO: Add Fn "Function" Symbol

// TODO: TDD? - To be refactored
extension String {
    func parseForControlCharacterMapping(separator: String = " ", returnType: ControlCharacterReturnType = .symbol) -> String {
        let segments = self.split(separator: " ")
        
        let replacedSegments = segments.map { segment -> String in
            let lowercasedSegment = segment.lowercased()
            
            if let replacements = ControlCharacterMappings.mappings[lowercasedSegment] {
                return replacements[returnType] ?? segment.uppercased()
            } else {
                return segment.uppercased()
            }
        }
        return replacedSegments.joined(separator: separator)
    }
}

struct ControlCharacterMappings {
    static let mappings: [String: [ControlCharacterReturnType: String]] = [
        "cmd": [
            .long: "Command",
            .short: "Cmd",
            .symbol: "\u{2318}"
        ],
        "ctrl": [
            .long: "Control",
            .short: "Ctrl",
            .symbol: "\u{2303}"
        ],
        "shift": [
            .long: "Shift",
            .short: "Shft",
            .symbol: "\u{21E7}"
        ],
        "opt": [
            .long: "Option",
            .short: "Opt",
            .symbol: "\u{2325}"
        ],
        "return": [
            .long: "Return",
            .short: "Rtn",
            .symbol: "\u{23CE}"
        ],
        "uparrow": [
            .long: "UpArrow",
            .short: "UArr",
            .symbol: "\u{2191}"
        ],
        "downarrow": [
            .long: "DownArrow",
            .short: "DArr",
            .symbol: "\u{2193}"
        ],
        "rightarrow": [
            .long: "RightArrow",
            .short: "RArr",
            .symbol: "\u{2192}"
        ],
        "leftarrow": [
            .long: "LeftArrow",
            .short: "LArr",
            .symbol: "\u{2190}"
        ],
        "tab": [
            .long: "Tab",
            .short: "Tab",
            .symbol: "\u{21E5}"
        ]
    ]
}

enum ControlCharacterReturnType {
    case long
    case short
    case symbol
}

extension UserDefaults {
    /// Returns a new instance of UserDefaults that's isolated for previews.
    static func previewUserDefaults() -> UserDefaults {
        let suiteName = "net.perlguy.MyXcodeShortcuts.preview"
        UserDefaults().removePersistentDomain(forName: suiteName)
        guard let defaults = UserDefaults(suiteName: suiteName) else {
            fatalError("Could not create preview UserDefaults")
        }
        return defaults
    }
}

extension StatusManager {
    func keyCombination(from example: String) -> String {
        
        return example.parseForControlCharacterMapping(separator: separator, returnType: showSymbols ? .symbol : .long)
    }
}
