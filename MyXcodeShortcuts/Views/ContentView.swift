//
//  ContentView.swift
//  MyXcodeShortcuts
//
//  Created by Brent Michalski on 4/1/24.
//

import SwiftUI
import SwiftData
import PDFKit

@MainActor
struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(StatusManager.self) private var statusManager
    
    @State private var navigationPath = NavigationPath()
    @State private var sortOrder = [SortDescriptor(\Category.name)]

    @Query private var categories: [Category]
    @Query(sort: \ShortcutApp.name) private var shortcutApps: [ShortcutApp]

    /// The collection currently selected as active (see CollectionsView). Falls back to the
    /// first available `ShortcutApp` when nothing has been explicitly chosen yet.
    private var activeShortcutApp: ShortcutApp? {
        if let uuid = UUID(uuidString: statusManager.activeShortcutAppID),
           let match = shortcutApps.first(where: { $0.id == uuid }) {
            return match
        }
        return shortcutApps.first
    }

    private var visibleCategories: [Category] {
        guard let activeShortcutApp else { return categories }
        return categories.filter { $0.shortcutApp?.id == activeShortcutApp.id }
    }

    var body: some View {
        return NavigationStack(path: $navigationPath) {

            VStack {
                Text(statusManager.currentStatus.headingValue)
                    .font(.caption)

                CategoryListView(navigationPath: $navigationPath, sortOrder: sortOrder, activeShortcutAppID: activeShortcutApp?.id)
                    .toolbar {
                        ToolbarItemGroup(placement: .topBarLeading) {
                            filtertoolbarItem()
                            sortOrderToolbarItem()
                        }
                        ToolbarItemGroup(placement: .topBarTrailing) {
                            collectionsToolbarItem()
                            addItemToolbarItem()
                            settingsToolbarItem()
                        }
                    }
            }
            .navigationTitle(activeShortcutApp?.name ?? "My Shortcuts")
            .navigationDestination(for: Shortcut.self) { shortcut in
                EditShortcutView(navigationPath: $navigationPath, shortcut: shortcut)
            }
            .navigationDestination(for: Category.self) { category in
                EditCategoryView(category: category)
            }
            .navigationDestination(for: String.self) { destination in
                switch destination {
                case "Settings":
                    SettingsView(pdfViewModel: PDFViewModel(categories: visibleCategories, statusManager: statusManager))
                case "Collections":
                    CollectionsView()
                default:
                    Text("Tried to navigate to: \(destination)")
                }
            }
        }
    }
    
    private func addItem() {
        withAnimation {
            let newShortcut = Shortcut(keyCombo: "", details: "")
            modelContext.insert(newShortcut)
            try? modelContext.save()
            navigationPath.append(newShortcut)
        }
    }
    
    private func sortOrderToolbarItem() -> some View {
        Menu("Sort", systemImage: "arrow.up.arrow.down") {
            Picker("Sort", selection: $sortOrder) {
                Text("Name (A-Z)").tag([SortDescriptor(\Category.name)])
                Text("Name (Z-A)").tag([SortDescriptor(\Category.name, order: .reverse)])
            }
        }
    }
    
    private func filtertoolbarItem() -> some View {
        Button {
            withAnimation {
                statusManager.toggleStatus()
            }
        } label: {
            Image(systemName: "line.3.horizontal.decrease.circle")
                .font(.title2)
                .foregroundStyle(ThemeManager.filterButtonColor(for: statusManager.currentStatus))
        }
    }
    
    private func settingsToolbarItem() -> some View {
        return NavigationLink(value: "Settings") {
            Label("Settings", systemImage: "gear")
        }
    }

    private func collectionsToolbarItem() -> some View {
        return NavigationLink(value: "Collections") {
            Label("Collections", systemImage: "square.stack.3d.up")
        }
    }
    
    private func addItemToolbarItem() -> some View {
        Button(action: addItem) {
            Label("Add Item", systemImage: "plus")
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
        
        return ContentView()
            .preferredColorScheme(.light)
            .modelContainer(container)
            .environment(statusManager)
    } catch {
        return Text("Failed to create a model container")
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
        
        return ContentView()
            .preferredColorScheme(.dark)
            .modelContainer(container)
            .environment(statusManager)
    } catch {
        return Text("Failed to create a model container")
    }
}
