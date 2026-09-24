//
//  MyXcodeShortcutsMacApp.swift
//  MyXcodeShortcutsMac
//
//  GUI front end for the ShortcutScraping library - pick a running app, walk its
//  menu bar via the Accessibility API, and export the shortcuts as JSON in the
//  same shape MyXcodeShortcuts imports (see SeedData.swift / SeedData_Release_1.json).
//

import SwiftUI

@main
struct MyXcodeShortcutsMacApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowResizability(.contentSize)
    }
}
