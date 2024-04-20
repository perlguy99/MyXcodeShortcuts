//
//  CategoryView.swift
//  MyXcodeShortcuts
//
//  Created by Brent Michalski on 4/1/24.
//

import SwiftUI
import SwiftData

struct CategoryView: View {
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var statusManager: StatusManager
    @Binding var navigationPath: NavigationPath
    
    var category: Category
    
    var filteredShortcuts: [Shortcut] {
        category.shortcuts.sorted { $0.details < $1.details }.filter { $0.matchesStatus(statusManager.currentStatus.intValue) }
    }
    
    var body: some View {
        Section(header: Text(category.name).textCase(nil)) {
            
            ForEach(filteredShortcuts) { shortcut in
                ShortcutView(navigationPath: $navigationPath, shortcut: shortcut)
            }
            .onDelete(perform: deleteShortcuts)
        }
        .foregroundColor(.red)
        .font(.headline)
        .bold()
    }
    
    private func deleteShortcuts(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(category.shortcuts[index])
            }
        }
    }
}

#Preview {
    let statusManager = StatusManager(userDefaults: UserDefaults.previewUserDefaults())
    statusManager.showSymbols = true
    
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Category.self, configurations: config)
        
        let previewHelper = PreviewHelper(container: container)
        previewHelper.loadSampleData()
        
        return CategoryView(navigationPath: .constant(NavigationPath()), category: previewHelper.previewCategory)
            .modelContainer(container)
            .environmentObject(statusManager)
        
    } catch {
        return Text("Failed to create a model container")
    }
}

#Preview {
    let statusManager = StatusManager(userDefaults: UserDefaults.previewUserDefaults())
    statusManager.showSymbols = false
    
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Category.self, configurations: config)
        
        let previewHelper = PreviewHelper(container: container)
        previewHelper.loadSampleData()
        
        return CategoryView(navigationPath: .constant(NavigationPath()), category: previewHelper.previewCategory)
            .modelContainer(container)
            .environmentObject(statusManager)
        
    } catch {
        return Text("Failed to create a model container")
    }
}
