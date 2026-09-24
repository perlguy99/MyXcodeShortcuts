//
//  main.swift
//  ShortcutExtractor
//
//  Standalone CLI tool: reads a running app's real menu-bar shortcuts via the
//  Accessibility API and writes JSON in the same shape MyXcodeShortcuts already
//  imports for its seed data (see SeedData.swift / SeedData_Release_1.json).
//
//  The actual AX-walking logic lives in the shared ShortcutScraping library
//  (tools/ShortcutScraping/) so it can also be driven from the ShortcutExporterMac
//  GUI app without duplicating it.
//
//  Usage: ShortcutExtractor <bundle-identifier> [--output <path>]
//  Example: ShortcutExtractor com.apple.finder --output finder-shortcuts.json
//
//  Requires Accessibility permission (System Settings > Privacy & Security >
//  Accessibility) granted to whatever process runs this (Terminal, if invoked
//  via `swift run`).
//

import Foundation
import ShortcutScraping

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

let result: CategoriesOut
do {
    result = try ShortcutScraper.extractShortcuts(bundleIdentifier: bundleIdentifier)
} catch {
    fail(error.localizedDescription)
}

let data: Data
do {
    data = try ShortcutScraper.encode(result)
} catch {
    fail("Failed to encode shortcuts: \(error.localizedDescription)")
}

if let outputPath {
    try! data.write(to: URL(fileURLWithPath: outputPath))
    print("Wrote \(result.categories.count) categories to \(outputPath)")
} else {
    print(String(data: data, encoding: .utf8) ?? "")
}
