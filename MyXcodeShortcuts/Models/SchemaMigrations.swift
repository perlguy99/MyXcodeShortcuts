//
//  SchemaMigrations.swift
//  MyXcodeShortcuts
//
//  Versioned schema history for SwiftData, so future schema changes have a real migration
//  path instead of relying on implicit lightweight migration forever. SchemaV1 is a frozen
//  snapshot of the shape the app shipped with before ShortcutApp existed (pre-2026-09-05);
//  SchemaV2 is the current shape and points straight at the app's live model types - only
//  older, superseded versions need their own dedicated frozen types.
//
//  When the schema changes again: add a SchemaV3 (frozen copy of what SchemaV2 looked like
//  at that point), update CurrentSchema/CurrentMigrationPlan below to describe the new
//  live shape and the V2 -> V3 stage, and reuse the pattern.
//

import Foundation
import SwiftData

enum SchemaV1: VersionedSchema {
    static var versionIdentifier: Schema.Version { Schema.Version(1, 0, 0) }
    static var models: [any PersistentModel.Type] { [Category.self, Shortcut.self] }

    @Model
    final class Category {
        var name: String = ""
        @Relationship(deleteRule: .cascade, inverse: \Shortcut.category) var shortcuts: [Shortcut] = []

        init(name: String) {
            self.name = name
        }
    }

    @Model
    final class Shortcut {
        var keyCombo: String = ""
        var details: String = ""
        var category: Category?
        var status: Status = Status.none

        init(keyCombo: String, details: String, status: Status = .none, category: Category? = nil) {
            self.keyCombo = keyCombo
            self.details = details
            self.status = status
            self.category = category
        }
    }
}

enum SchemaV2: VersionedSchema {
    static var versionIdentifier: Schema.Version { Schema.Version(2, 0, 0) }
    static var models: [any PersistentModel.Type] { [ShortcutApp.self, Category.self, Shortcut.self] }

    // Frozen snapshot of the whole model trio as they looked before `order` was added in V3.
    // Reusing the live ShortcutApp type here (since its shape doesn't change between V2 and
    // V3) crashes SwiftData's migration graph at runtime - every model referenced by a
    // non-current schema needs its own dedicated frozen type, even an unchanged one.
    @Model
    final class ShortcutApp {
        var id: UUID = UUID()
        var name: String = ""
        @Relationship(deleteRule: .cascade, inverse: \Category.shortcutApp) var categories: [Category] = []

        init(name: String) {
            self.name = name
        }
    }

    @Model
    final class Category {
        var name: String = ""
        @Relationship(deleteRule: .cascade, inverse: \Shortcut.category) var shortcuts: [Shortcut] = []
        var shortcutApp: ShortcutApp?

        init(name: String) {
            self.name = name
        }
    }

    @Model
    final class Shortcut {
        var keyCombo: String = ""
        var details: String = ""
        var category: Category?
        var status: Status = Status.none

        init(keyCombo: String, details: String, status: Status = .none, category: Category? = nil) {
            self.keyCombo = keyCombo
            self.details = details
            self.status = status
            self.category = category
        }
    }
}

enum SchemaV3: VersionedSchema {
    static var versionIdentifier: Schema.Version { Schema.Version(3, 0, 0) }
    static var models: [any PersistentModel.Type] { [ShortcutApp.self, Category.self, Shortcut.self] }
}

enum MigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] { [SchemaV1.self, SchemaV2.self, SchemaV3.self] }

    static var stages: [MigrationStage] {
        [
            // Purely additive (a new ShortcutApp model, a new optional Category.shortcutApp
            // relationship) - SwiftData can infer this migration on its own.
            .lightweight(fromVersion: SchemaV1.self, toVersion: SchemaV2.self),
            // Purely additive (a new `order: Int = 0` on both Category and Shortcut) -
            // every existing row gets 0, which just means "unordered" until the user's
            // next import/seed/reorder actually assigns real positions.
            .lightweight(fromVersion: SchemaV2.self, toVersion: SchemaV3.self)
        ]
    }
}

typealias CurrentSchema = SchemaV3
