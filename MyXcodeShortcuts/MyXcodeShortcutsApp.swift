//
//  MyXcodeShortcutsApp.swift
//  MyXcodeShortcuts
//
//  Created by Brent Michalski on 4/1/24.
//

import SwiftUI
import SwiftData
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
@MainActor
struct MyXcodeShortcutsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([Category.self, Shortcut.self])
        
        #if targetEnvironment(simulator)
        let isStoredInMemoryOnly = true
        #else
        let isStoredInMemoryOnly = false
        #endif
        
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: isStoredInMemoryOnly)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    func checkSeed() {
        let seed = SeedData(modelContext: sharedModelContainer.mainContext)
        seed.loadSeedData()
    }
    
    var body: some Scene {
        let _ = checkSeed()
        
        WindowGroup {
            return ContentView()
        }
        .modelContainer(sharedModelContainer)
        .environmentObject(StatusManager())
    }
}
