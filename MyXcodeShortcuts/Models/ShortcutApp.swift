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
    var name: String = ""
    @Relationship(deleteRule: .cascade, inverse: \Category.shortcutApp) var categories: [Category] = [Category]()

    init(name: String) {
        self.name = name
    }
}
