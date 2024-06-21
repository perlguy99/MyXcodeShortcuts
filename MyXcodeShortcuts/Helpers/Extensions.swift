//
//  Extensions.swift
//  MyXcodeShortcuts
//
//  Created by Brent Michalski on 4/1/24.
//

import Foundation
import SwiftUI
import SwiftData
import PDFKit

extension Binding where Value == String? {
    /// Creates a non-optional `Binding<String>` from `Binding<String?>` with a default value for `nil`.
    func replacingNilWith(_ defaultValue: String) -> Binding<String> {
        Binding<String>(
            get: { self.wrappedValue ?? defaultValue },
            set: { self.wrappedValue = $0 }
        )
    }
}

extension ModelContext {
    var sqliteCommand: String {
        if let url = container.configurations.first?.url.path(percentEncoded: false) {
            return "sqlite3 \"\(url)\""
        } else {
            return "No SQLite database found."
        }
    }
}

extension Data {
    var prettyPrintedJSONString: NSString? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        else { return nil }
        
        return prettyPrintedString
    }
}

extension Encodable {
    var encoded: Data? {
        try? JSONEncoder().encode(self)
    }
}

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

extension UIPrintFormatter {
    convenience init?(pdfData: Data) {
        guard let pdfDocument = PDFDocument(data: pdfData) else { return nil }
        
        self.init()
        self.perPageContentInsets = .zero   // Adjust if I find that I need margins
        self.startPage = 0
        self.maximumContentHeight = pdfDocument.page(at: 0)?.bounds(for: .mediaBox).height ?? 792 // Standard US Letter height in points
        self.maximumContentWidth = pdfDocument.page(at: 0)?.bounds(for: .mediaBox).width ?? 612 // Standard US Letter height in points
    }
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
