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
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            
            VStack {
                Text(currentStatus.headingValue)
                    .font(.caption)
                
//                List(categories, id: \.self) { category in
//                    Section(header: Text(category.name)) {
//                        ForEach(category.shortcuts, id: \.self) { shortcut in
//                            
//                        }
//                    }
//                }
                
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
    
    private func addItemToolbarItem() -> some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: addItem) {
                Label("Add Item", systemImage: "plus")
            }
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
