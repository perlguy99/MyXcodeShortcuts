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
    var isNotEmpty: Bool {
        return !isEmpty
    }
}

// TODO: Add Fn "Function" Symbol

extension String {
    func replacingKeywordsWithSymbols(separator: String = "*") -> String {
        return replaceKeywords(using: separator) { symbol, _ in symbol }
    }
    
    func replacingKeywordsWithFullWords(separator: String = "∞") -> String {
        return replaceKeywords(using: separator) { _, fullWord in fullWord }
    }
    
    private func replaceKeywords(using separator: String, replacementSelector: (String, String) -> String) -> String {
        let segments = self.split(separator: " ")
        
        let replacedSegments = segments.map { segment -> String in
            let lowercasedSegment = segment.lowercased()

            if let symbolDetails = KeyboardSymbols.symbols[lowercasedSegment] {
                return replacementSelector(symbolDetails.0, symbolDetails.1)
            } else {
                return String(segment)
            }
        }
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
    }
}
