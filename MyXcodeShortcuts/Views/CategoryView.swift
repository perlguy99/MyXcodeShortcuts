//
//  CategoryView.swift
//  MyXcodeShortcuts
//
//  Created by Brent Michalski on 4/1/24.
//

import SwiftUI
import SwiftData

struct CategoryView: View {
    @Environment(StatusManager.self) private var statusManager

    var category: Category

    var filteredShortcuts: [Shortcut] {
        category.shortcuts.sorted { $0.details < $1.details }.filter { $0.matchesStatus(statusManager.currentStatus.intValue) }
    }

    var body: some View {
        Section(header: Text(category.name).textCase(nil)) {
            ForEach(filteredShortcuts) { shortcut in
                ShortcutView(shortcut: shortcut)
            }
        }
        .foregroundStyle(ThemeManager.categoryHeaderTextColor)
        .font(.headline)
        .bold()
    }
}

#Preview {
    let statusManager = StatusManager()
    statusManager.showSymbols = true
    
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Category.self, configurations: config)
        
        let previewHelper = PreviewHelper(container: container)
        previewHelper.loadSampleData()
        
        return CategoryView(category: previewHelper.previewCategory)
            .modelContainer(container)
            .environment(statusManager)
        
    } catch {
        return Text("Failed to create a model container")
    }
}

#Preview {
    let statusManager = StatusManager()
    statusManager.showSymbols = false
    
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Category.self, configurations: config)
        
        let previewHelper = PreviewHelper(container: container)
        previewHelper.loadSampleData()
        
        return CategoryView(category: previewHelper.previewCategory)
            .modelContainer(container)
            .environment(statusManager)
        
    } catch {
        return Text("Failed to create a model container")
    }
}
