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
    @EnvironmentObject var statusManager: StatusManager
    
    @State private var navigationPath = NavigationPath()
    @State private var sortOrder = [SortDescriptor(\Category.name)]
    
    @Query private var categories: [Category]
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            
            VStack {
                Text(statusManager.currentStatus.headingValue)
                    .font(.caption)
                
                CategoryListView(navigationPath: $navigationPath, sortOrder: sortOrder)
                    .navigationTitle("My Xcode Shortcuts")
                    .navigationDestination(for: Shortcut.self) { shortcut in
                        EditShortcutView(navigationPath: $navigationPath, shortcut: shortcut)
                    }
                    .navigationDestination(for: Category.self) { category in
                        EditCategoryView(category: category)
                    }
                    .toolbar {
                        ToolbarItemGroup(placement: .topBarLeading) {
                            sortOrderToolbarItem()
                            filtertoolbarItem()
                        }
                        ToolbarItemGroup(placement: .topBarTrailing) {
                            addItemToolbarItem()
                            settingsToolbarItem()
                        }
                }
            }
        }
    }
    
    private func addItem() {
        withAnimation {
            let newShortcut = Shortcut(keyCombo: "", details: "")
            modelContext.insert(newShortcut)
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
                .foregroundStyle(statusManager.currentStatus.color)
        }
    }
    
    private func settingsToolbarItem() -> some View {
        NavigationLink(destination: SettingsView()) {
            Image(systemName: "gear")
        }
    }

    private func addItemToolbarItem() -> some View {
        Button(action: addItem) {
            Label("Add Item", systemImage: "plus")
        }
    }
    
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Category.self, configurations: config)
        
        let previewHelper = PreviewHelper(container: container)
        previewHelper.loadSampleData()

        return ContentView()
            .modelContainer(container)
    } catch {
        return Text("Failed to create a model container")
    }

}
