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
        return NavigationStack(path: $navigationPath) {
            
            VStack {
                Text(statusManager.currentStatus.headingValue)
                    .font(.caption)
                
                CategoryListView(navigationPath: $navigationPath, sortOrder: sortOrder)
                    .navigationTitle("My Shortcuts")
                    .navigationDestination(for: Shortcut.self) { shortcut in
                        EditShortcutView(navigationPath: $navigationPath, shortcut: shortcut)
                    }
                    .navigationDestination(for: Category.self) { category in
                        EditCategoryView(category: category)
                    }
                    .toolbar {
                        ToolbarItemGroup(placement: .topBarLeading) {
                            filtertoolbarItem()
                            sortOrderToolbarItem()
                        }
                        ToolbarItemGroup(placement: .topBarTrailing) {
                            addItemToolbarItem()
                            settingsToolbarItem()
//                            #if DEBUG
//                            deleteAllToolbarItem()
//                            #endif
                        }
                    }
            }
        }
    }
    
    // TODO: Delete me
//    #if DEBUG
//    private func deleteAll() {
//        print("private func deleteAll()")
//        for category in categories {
//            modelContext.container.mainContext.delete(category)
//        }
//    }
//    
//    private func deleteAllToolbarItem() -> some View {
//        Button(action: deleteAll) {
//            Label("Delete All Items", systemImage: "exclamationmark.octagon")
//        }
//    }
//    #endif
    
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
                .foregroundStyle(ThemeManager.filterButtonColor(for: statusManager.currentStatus))
        }
    }
    
    private func settingsToolbarItem() -> some View {
        let pdfViewModel = PDFViewModel(categories: categories, statusManager: statusManager)
        
        return NavigationLink(destination: SettingsView(pdfViewModel: pdfViewModel)) {
            Image(systemName: "gear")
                .resizable()
                .frame(width: 30, height: 30)
        }
    }
    
    private func addItemToolbarItem() -> some View {
        Button(action: addItem) {
            Label("Add Item", systemImage: "plus")
                .frame(width: 30, height: 30)
            
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
        
        return ContentView()
            .preferredColorScheme(.light)
            .modelContainer(container)
            .environmentObject(statusManager)
    } catch {
        return Text("Failed to create a model container")
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
        
        return ContentView()
            .preferredColorScheme(.dark)
            .modelContainer(container)
            .environmentObject(statusManager)
    } catch {
        return Text("Failed to create a model container")
    }
}
