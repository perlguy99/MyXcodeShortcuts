//
//  ShortcutScraping.swift
//  ShortcutScraping
//
//  Shared library: reads a running app's real menu-bar shortcuts via the
//  Accessibility API and produces JSON in the same shape MyXcodeShortcuts
//  already imports for its seed data (see SeedData.swift / SeedData_Release_1.json).
//
//  This is the AX-walking logic factored out of the ShortcutExtractor CLI tool
//  so it can also be driven from a GUI app (ShortcutExporterMac) without
//  duplicating it. Behavior is unchanged from the original CLI implementation.
//
//  Requires Accessibility permission (System Settings > Privacy & Security >
//  Accessibility) granted to whatever process calls into this library.
//

import AppKit
import ApplicationServices
import Foundation

// MARK: - Output shape

public struct ShortcutOut: Codable, Equatable {
    public let keyCombo: String
    public let details: String

    public init(keyCombo: String, details: String) {
        self.keyCombo = keyCombo
        self.details = details
    }
}

public struct CategoryOut: Codable, Equatable {
    public let name: String
    public let shortcuts: [ShortcutOut]

    public init(name: String, shortcuts: [ShortcutOut]) {
        self.name = name
        self.shortcuts = shortcuts
    }
}

public struct CategoriesOut: Codable, Equatable {
    public let categories: [CategoryOut]

    public init(categories: [CategoryOut]) {
        self.categories = categories
    }
}

// MARK: - Errors

public enum ShortcutScrapingError: Error, LocalizedError {
    case accessibilityPermissionDenied
    case appNotRunning(bundleIdentifier: String)
    case noMenuBar(bundleIdentifier: String)

    public var errorDescription: String? {
        switch self {
        case .accessibilityPermissionDenied:
            return """
            Accessibility permission not granted.
            Open System Settings > Privacy & Security > Accessibility, enable this app, then try again.
            """
        case .appNotRunning(let bundleIdentifier):
            return "No running app with bundle identifier '\(bundleIdentifier)'. Launch it first, then try again."
        case .noMenuBar(let bundleIdentifier):
            return "Could not read the menu bar for '\(bundleIdentifier)'."
        }
    }
}

// MARK: - Scraper

public enum ShortcutScraper {

    /// Whether the current process has Accessibility permission. Callers should
    /// check this (and prompt the user to grant it in System Settings) before
    /// calling `extractShortcuts`.
    /// Checks Accessibility trust. Passing the prompt option makes macOS show the
    /// real system permission dialog and add the calling process to the
    /// Accessibility list itself (unchecked) the first time this runs, instead of
    /// silently returning false and leaving the user to hunt it down manually.
    public static func isAccessibilityTrusted() -> Bool {
        let options: [String: Any] = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
        return AXIsProcessTrustedWithOptions(options as CFDictionary)
    }

    /// Walks the live menu bar of the running app with the given bundle identifier
    /// and returns its shortcuts grouped by top-level menu (one category per menu,
    /// skipping the app's own Apple-style app menu, same as the original CLI tool).
    public static func extractShortcuts(bundleIdentifier: String) throws -> CategoriesOut {
        guard AXIsProcessTrusted() else {
            throw ShortcutScrapingError.accessibilityPermissionDenied
        }

        guard let targetApp = NSWorkspace.shared.runningApplications.first(where: { $0.bundleIdentifier == bundleIdentifier }) else {
            throw ShortcutScrapingError.appNotRunning(bundleIdentifier: bundleIdentifier)
        }

        let appElement = AXUIElementCreateApplication(targetApp.processIdentifier)

        guard let menuBar: AXUIElement = attribute(appElement, kAXMenuBarAttribute) else {
            throw ShortcutScrapingError.noMenuBar(bundleIdentifier: bundleIdentifier)
        }

        var categories: [CategoryOut] = []

        // The first menu bar item is the app's own name (the "Apple-style" app menu) - it
        // holds About/Quit/Services, nothing worth a dedicated category.
        for topLevelItem in children(menuBar).dropFirst() {
            guard let title: String = attribute(topLevelItem, kAXTitleAttribute), title.isEmpty == false else { continue }
            guard let submenu = children(topLevelItem).first else { continue }

            var shortcuts: [ShortcutOut] = []
            collectShortcuts(from: submenu, into: &shortcuts)

            if shortcuts.isEmpty == false {
                categories.append(CategoryOut(name: title, shortcuts: shortcuts))
            }
        }

        return CategoriesOut(categories: categories)
    }

    /// Encodes `CategoriesOut` the same way the original CLI tool did (pretty-printed,
    /// sorted keys) so output is byte-identical regardless of which caller produced it.
    public static func encode(_ categories: CategoriesOut) throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return try encoder.encode(categories)
    }

    // MARK: AX helpers

    private static func attribute<T>(_ element: AXUIElement, _ name: String) -> T? {
        var value: CFTypeRef?
        let result = AXUIElementCopyAttributeValue(element, name as CFString, &value)
        guard result == .success else { return nil }
        return value as? T
    }

    private static func children(_ element: AXUIElement) -> [AXUIElement] {
        attribute(element, kAXChildrenAttribute) ?? []
    }

    // Special keys report through cmdChar as private-use/control characters rather than
    // printable text. Map the common ones to the token names MyXcodeShortcuts already
    // knows how to render as symbols (see ControlCharacterMappings in Extensions.swift).
    // Anything not listed here still comes through, just as plain uppercased text.
    private static func token(forCmdChar char: Character) -> String {
        switch char {
        case "\u{F700}": return "uparrow"
        case "\u{F701}": return "downarrow"
        case "\u{F702}": return "leftarrow"
        case "\u{F703}": return "rightarrow"
        case "\t": return "tab"
        case "\r", "\n": return "return"
        case "\u{1B}": return "esc"
        case " ": return "space"
        case "\u{7F}", "\u{8}": return "delete"
        default: return String(char)
        }
    }

    // Used when a menu item has no cmdChar but does have a virtual keycode (arrows are
    // the common case). Keycodes below are the standard macOS ANSI virtual keycodes.
    private static func token(forVirtualKey keyCode: Int) -> String? {
        switch keyCode {
        case 123: return "leftarrow"
        case 124: return "rightarrow"
        case 125: return "downarrow"
        case 126: return "uparrow"
        case 48: return "tab"
        case 36: return "return"
        case 51: return "delete"
        case 53: return "esc"
        case 49: return "space"
        default: return nil
        }
    }

    // Carbon menu-manager modifier bits: kMenuShiftModifier=1, kMenuOptionModifier=2,
    // kMenuControlModifier=4, kMenuNoCommandModifier=8 (Command is implied unless that
    // bit is set). This is what AXMenuItemCmdModifiers actually returns.
    private static func modifierTokens(_ modifiers: Int) -> [String] {
        var tokens: [String] = []
        if modifiers & 0x04 != 0 { tokens.append("Ctrl") }
        if modifiers & 0x02 != 0 { tokens.append("Opt") }
        if modifiers & 0x01 != 0 { tokens.append("Shift") }
        if modifiers & 0x08 == 0 { tokens.append("Cmd") }
        return tokens
    }

    private static func keyCombo(for item: AXUIElement) -> String? {
        var keyToken: String?

        if let cmdChar: String = attribute(item, kAXMenuItemCmdCharAttribute), let firstChar = cmdChar.first {
            keyToken = token(forCmdChar: firstChar)
        } else if let virtualKey: Int = attribute(item, kAXMenuItemCmdVirtualKeyAttribute), virtualKey != -1 {
            keyToken = token(forVirtualKey: virtualKey)
        }

        guard let keyToken, keyToken.isEmpty == false else { return nil }

        let modifiers: Int = attribute(item, kAXMenuItemCmdModifiersAttribute) ?? 0
        let finalKeyToken = keyToken.count == 1 ? keyToken.uppercased() : keyToken
        return (modifierTokens(modifiers) + [finalKeyToken]).joined(separator: " ")
    }

    private static func collectShortcuts(from menu: AXUIElement, into shortcuts: inout [ShortcutOut]) {
        for item in children(menu) {
            let role: String = attribute(item, kAXRoleAttribute) ?? ""
            guard role == kAXMenuItemRole else { continue }

            // A submenu is a menu item whose only child is the nested AXMenu - recurse into it.
            if let submenu = children(item).first {
                collectShortcuts(from: submenu, into: &shortcuts)
                continue
            }

            guard let title: String = attribute(item, kAXTitleAttribute), title.isEmpty == false else { continue }
            guard let combo = keyCombo(for: item) else { continue }
            shortcuts.append(ShortcutOut(keyCombo: combo, details: title))
        }
    }
}
