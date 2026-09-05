//
//  main.swift
//  ShortcutExtractor
//
//  Standalone CLI tool: reads a running app's real menu-bar shortcuts via the
//  Accessibility API and writes JSON in the same shape MyXcodeShortcuts already
//  imports for its seed data (see SeedData.swift / SeedData_Release_1.json).
//
//  Usage: ShortcutExtractor <bundle-identifier> [--output <path>]
//  Example: ShortcutExtractor com.apple.finder --output finder-shortcuts.json
//
//  Requires Accessibility permission (System Settings > Privacy & Security >
//  Accessibility) granted to whatever process runs this (Terminal, if invoked
//  via `swift run`).
//

import AppKit
import ApplicationServices
import Foundation

struct ShortcutOut: Codable {
    let keyCombo: String
    let details: String
}

struct CategoryOut: Codable {
    let name: String
    let shortcuts: [ShortcutOut]
}

struct CategoriesOut: Codable {
    let categories: [CategoryOut]
}

func fail(_ message: String) -> Never {
    FileHandle.standardError.write((message + "\n").data(using: .utf8)!)
    exit(1)
}

let arguments = CommandLine.arguments
guard arguments.count >= 2 else {
    fail("Usage: ShortcutExtractor <bundle-identifier> [--output <path>]")
}
let bundleIdentifier = arguments[1]

var outputPath: String?
if let flagIndex = arguments.firstIndex(of: "--output"), flagIndex + 1 < arguments.count {
    outputPath = arguments[flagIndex + 1]
}

guard AXIsProcessTrusted() else {
    fail("""
    Accessibility permission not granted.
    Open System Settings > Privacy & Security > Accessibility, enable this tool \
    (or Terminal, if you're running this via `swift run`), then run again.
    """)
}

guard let targetApp = NSWorkspace.shared.runningApplications.first(where: { $0.bundleIdentifier == bundleIdentifier }) else {
    fail("No running app with bundle identifier '\(bundleIdentifier)'. Launch it first, then run again.")
}

let appElement = AXUIElementCreateApplication(targetApp.processIdentifier)

func attribute<T>(_ element: AXUIElement, _ name: String) -> T? {
    var value: CFTypeRef?
    let result = AXUIElementCopyAttributeValue(element, name as CFString, &value)
    guard result == .success else { return nil }
    return value as? T
}

func children(_ element: AXUIElement) -> [AXUIElement] {
    attribute(element, kAXChildrenAttribute) ?? []
}

guard let menuBar: AXUIElement = attribute(appElement, kAXMenuBarAttribute) else {
    fail("Could not read the menu bar for '\(bundleIdentifier)'.")
}

// Special keys report through cmdChar as private-use/control characters rather than
// printable text. Map the common ones to the token names MyXcodeShortcuts already
// knows how to render as symbols (see ControlCharacterMappings in Extensions.swift).
// Anything not listed here still comes through, just as plain uppercased text.
func token(forCmdChar char: Character) -> String {
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
func token(forVirtualKey keyCode: Int) -> String? {
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
func modifierTokens(_ modifiers: Int) -> [String] {
    var tokens: [String] = []
    if modifiers & 0x04 != 0 { tokens.append("Ctrl") }
    if modifiers & 0x02 != 0 { tokens.append("Opt") }
    if modifiers & 0x01 != 0 { tokens.append("Shift") }
    if modifiers & 0x08 == 0 { tokens.append("Cmd") }
    return tokens
}

func keyCombo(for item: AXUIElement) -> String? {
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

func collectShortcuts(from menu: AXUIElement, into shortcuts: inout [ShortcutOut]) {
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

let result = CategoriesOut(categories: categories)
let encoder = JSONEncoder()
encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
let data = try! encoder.encode(result)

if let outputPath {
    try! data.write(to: URL(fileURLWithPath: outputPath))
    print("Wrote \(categories.count) categories to \(outputPath)")
} else {
    print(String(data: data, encoding: .utf8) ?? "")
}
