//
//  ShortcutImporter.swift
//  MyXcodeShortcuts
//
//  Decodes JSON produced by the standalone ShortcutExtractor CLI tool (or any file matching
//  its {"categories":[{"name":...,"shortcuts":[{"keyCombo":...,"details":...}]}]} shape - the
//  same shape SeedData.swift already parses for the built-in seed data) and builds a new
//  ShortcutApp collection from it.
//
//  Split into a pure decode step (`decodeCategories`, no SwiftData involved - easy to unit
//  test) and a SwiftData-touching build step (`importCollection`) that mirrors the exact
//  construction pattern SeedData.swift uses for the seeded "Xcode Shortcuts" collection.
//

import Foundation
import SwiftData

enum ShortcutImportError: LocalizedError, Equatable {
    case invalidJSON
    case noCategories

    var errorDescription: String? {
        switch self {
        case .invalidJSON:
            return "That file doesn't look like a shortcuts export. Make sure it's JSON produced by ShortcutExtractor."
        case .noCategories:
            return "That file doesn't contain any categories to import."
        }
    }
}

enum ShortcutImporter {
    /// Pure decode step: turns raw JSON `Data` into the categories/shortcuts it describes,
    /// without touching SwiftData. Throws `ShortcutImportError` on malformed or empty input.
    static func decodeCategories(from data: Data) throws -> [CategoryX] {
        let decoded: CategoriesX
        do {
            decoded = try JSONDecoder().decode(CategoriesX.self, from: data)
        } catch {
            throw ShortcutImportError.invalidJSON
        }

        guard decoded.categories.isNotEmpty else {
            throw ShortcutImportError.noCategories
        }

        return decoded.categories
    }

    /// Builds a new `ShortcutApp` named `name` plus its `Category`/`Shortcut` rows from decoded
    /// JSON data, inserting everything into `modelContext`. Same relationship wiring SeedData
    /// uses: the `ShortcutApp` is inserted first, then each `Category` is created, tagged with
    /// `shortcutApp`, and inserted, then its `Shortcut`s are appended.
    @MainActor
    @discardableResult
    static func importCollection(named name: String, from data: Data, into modelContext: ModelContext) throws -> ShortcutApp {
        let categories = try decodeCategories(from: data)

        let shortcutApp = ShortcutApp(name: name)
        modelContext.insert(shortcutApp)

        for category in categories {
            let currentCategory = Category(name: category.name)
            currentCategory.shortcutApp = shortcutApp
            modelContext.insert(currentCategory)

            guard let shortcuts = category.shortcuts, shortcuts.isNotEmpty else { continue }

            for shortcut in shortcuts {
                let currentShortcut = Shortcut(keyCombo: shortcut.keyCombo, details: shortcut.details, status: .none, category: currentCategory)
                currentCategory.shortcuts.append(currentShortcut)
            }
        }

        try modelContext.save()
        return shortcutApp
    }
}
