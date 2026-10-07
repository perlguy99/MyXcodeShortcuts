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
        category.shortcuts.sorted { $0.order < $1.order }.filter { $0.matchesStatus(statusManager.currentStatus.intValue) }
    }

    var body: some View {
        Section(header: Text(category.name).textCase(nil)) {
            ForEach(filteredShortcuts) { shortcut in
                ShortcutView(shortcut: shortcut)
            }
            .onMove(perform: moveShortcuts)
        }
        .foregroundStyle(ThemeManager.categoryHeaderTextColor)
        .font(.headline)
        .bold()
    }

    /// Reorders only the currently-visible (status-filtered) shortcuts, splicing the result
    /// back into the category's full shortcut list at their original slots - so a shortcut
    /// hidden by the current status filter keeps its relative position instead of getting
    /// pulled to one end by a reorder it wasn't even part of.
    private func moveShortcuts(from source: IndexSet, to destination: Int) {
        var reordered = filteredShortcuts
        reordered.move(fromOffsets: source, toOffset: destination)

        var fullOrder = category.shortcuts.sorted { $0.order < $1.order }
        let visibleIDs = Set(filteredShortcuts.map(\.persistentModelID))
        var reorderedIterator = reordered.makeIterator()
        for index in fullOrder.indices where visibleIDs.contains(fullOrder[index].persistentModelID) {
            fullOrder[index] = reorderedIterator.next() ?? fullOrder[index]
        }

        for (index, shortcut) in fullOrder.enumerated() {
            shortcut.order = index
        }
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
