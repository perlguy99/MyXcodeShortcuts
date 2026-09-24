//
//  ShortcutApp.swift
//  MyXcodeShortcuts
//
//  Created by Brent Michalski on 9/5/26.
//

import Foundation
import SwiftData

@Model
class ShortcutApp {
    /// Stable identifier used to remember which collection is "active" (e.g. persisted in
    /// UserDefaults via StatusManager) across launches, independent of SwiftData's internal
    /// persistentModelID.
    var id: UUID = UUID()
    var name: String = ""
    @Relationship(deleteRule: .cascade, inverse: \Category.shortcutApp) var categories: [Category] = [Category]()

    init(name: String) {
        self.name = name
    }
}
