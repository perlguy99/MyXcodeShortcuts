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

extension String {
    var shortcutKeyComboString: String {
        self.replacingOccurrences(of: "Cmd", with: "\(Image(systemName: "command"))")
        
    }
}

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
    func replacingKeywordsWithSymbols(separator: String = "*") -> String {
        // Define the mappings from keywords to Unicode symbols
        let substitutions: [String: String] = [
            "cmd": "\u{2318}", // Command Key Symbol
            "ctrl": "\u{2303}", // Control Key Symbol
            "shift": "\u{21E7}", // Shift Key Symbol
            "opt": "\u{2325}", // Option (Alt) Key Symbol
            "return": "\u{23CE}", // Shift Key Symbol
        ]
        
        // Split the string into segments based on spaces
        let segments = self.split(separator: " ")
        
        // Replace each segment if it matches a keyword, ignoring case
        let replacedSegments = segments.map { segment -> String in
            let lowercasedSegment = segment.lowercased()
            if let replacement = substitutions[lowercasedSegment] {
                return replacement
            } else {
                return String(segment)
            }
        }
        
        // Join the segments back into a single string
        return replacedSegments.joined(separator: separator)
    }
    
    func replacingKeywordsWithFullWords(separator: String = "¶") -> String {
        // Define the mappings from keywords to Unicode symbols
        let substitutions: [String: String] = [
            "cmd": "Command", // Command Key Symbol
            "ctrl": "Control", // Control Key Symbol
            "shift": "Shift", // Shift Key Symbol
            "opt": "Option", // Option (Alt) Key Symbol
            "return": "Return", // Shift Key Symbol
        ]
        
        // Split the string into segments based on spaces
        let segments = self.split(separator: " ")
        
        // Replace each segment if it matches a keyword, ignoring case
        let replacedSegments = segments.map { segment -> String in
            let lowercasedSegment = segment.lowercased()
            if let replacement = substitutions[lowercasedSegment] {
                return replacement
            } else {
                return String(segment)
            }
        }
        
        // Join the segments back into a single string
        return replacedSegments.joined(separator: separator)
    }
}

extension UIPrintFormatter {
    convenience init?(pdfData: Data) {
        guard let pdfDocument = PDFDocument(data: pdfData) else { return nil }
        
        self.init()
        self.perPageContentInsets = .zero   // Adjust if I find that I need margins
        self.startPage = 0
        self.maximumContentHeight = pdfDocument.page(at: 0)?.bounds(for: .mediaBox).height ?? 792 // Standard US Letter height in points
        self.maximumContentWidth = pdfDocument.page(at: 0)?.bounds(for: .mediaBox).width ?? 612 // Standard US Letter height in points
        
        print("\n------------------------------")
        print(self.maximumContentHeight)
        print(self.maximumContentWidth)
        print("------------------------------\n")
    }
}
