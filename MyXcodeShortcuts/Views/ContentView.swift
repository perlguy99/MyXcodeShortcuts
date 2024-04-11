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
    
    @State private var navigationPath = NavigationPath()
    @State private var sortOrder = [SortDescriptor(\Category.name)]
    
    @AppStorage(Constants.Keys.statusInt.rawValue) var statusInt: Int = 0
    
    @Query private var categories: [Category]
    
    @State var currentStatus: Status = Status(rawValue: 0)
    
    // TODO: - figure out toolbar item order if needed
    var body: some View {
        NavigationStack(path: $navigationPath) {
            
            VStack {
                Text(currentStatus.headingValue)
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
                        sortOrderToolbarItem()
                        addItemToolbarItem()
                        filterToolbarItem()
                        settingsToolbarItem()
    //                    deleteAllToolbarItem()
                }
            }
            
        }
    }
    
    // TODO: Delete me
    private func deleteAll() {
        print("private func deleteAll()")
        for category in categories {
            modelContext.container.mainContext.delete(category)
        }
    }
    
    private func addItem() {
        withAnimation {
            let newShortcut = Shortcut(keyCombo: "", details: "")
            modelContext.insert(newShortcut)
            navigationPath.append(newShortcut)
        }
    }
    
    private func deleteCategories(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(categories[index])
            }
        }
    }
}

// MARK: - Toobar Items
extension ContentView {
    
    private func sortOrderToolbarItem() -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Menu("Sort", systemImage: "arrow.up.arrow.down") {
                Picker("Sort", selection: $sortOrder) {
                    Text("Name (A-Z)")
                        .tag([SortDescriptor(\Category.name)])
                    
                    Text("Name (Z-A)")
                        .tag([SortDescriptor(\Category.name, order: .reverse)])
                }
            }
        }
    }
    
    func filterToolbarItem() -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button {
                withAnimation {
                    currentStatus = Status(rawValue: statusInt)
                    currentStatus.toggle()
                    statusInt = currentStatus.rawValue
                }
            } label: {
                Image(systemName: "line.3.horizontal.decrease.circle")
            }
            .font(.title2)
            .foregroundStyle(currentStatus.color)
        }
    }
    
    private func settingsToolbarItem() -> some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            NavigationLink(destination: SettingsView()) {
                Image(systemName: "gear")
            }
        }
    }
    
    // TODO: Delete me
    private func deleteAllToolbarItem() -> some ToolbarContent {
        ToolbarItem {
            Button(action: deleteAll) {
                Label("Delete All", systemImage: "exclamationmark.warninglight.fill")
            }
        }
    }
    
    private func addItemToolbarItem() -> some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: addItem) {
                Label("Add Item", systemImage: "plus")
            }
        }
    }
}

#Preview {
    let statusManager = StatusManager()
    
    let previewHelper = PreviewHelper()
    previewHelper.loadSampleData()
    
    return ContentView()
        .modelContainer(previewHelper.container)
        .environmentObject(statusManager)
}


