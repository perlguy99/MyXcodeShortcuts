//
//  ContentView.swift
//  MyXcodeShortcuts
//
//  Created by Brent Michalski on 4/1/24.
//

import SwiftUI
import SwiftData

@MainActor
struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    @EnvironmentObject var checkboxState: SharedCheckboxState
    
    @State private var searchText = ""
    @State private var navigationPath = NavigationPath()
    @State private var sortOrder = [SortDescriptor(\Category.name)]
    
    @Query private var categories: [Category]
    
    @AppStorage(Constants.Keys.showHidden.rawValue) var showHidden: Bool = true
    
    // TODO: - figure out toolbar item order if needed
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack {
                Text("\(checkboxState.state)")
                
                CategoryListView(searchString: searchText, sortOrder: sortOrder)
                    .navigationTitle("My Xcode Shortcuts")
                    .navigationDestination(for: Shortcut.self) { shortcut in
                        EditShortcutView(navigationPath: $navigationPath, shortcut: shortcut)
//                            .environmentObject(checkboxState)
                    }
                
                    .toolbar {
                        getSortOrderToolbarItem()
                        getAddItemToolbarItem()
                        getFilterToolbarItem()
                        getSettingsToolbarItem()
                        getEditButtonToolbarItem()
                        //                    getDeleteAllToolbarItem()
                        //                    getLoadSeedDataToolbarItem()
                    }
                    .searchable(text: $searchText)
            }
        }
    }
    
    private func deleteAll() {
        print("private func deleteAll()")
        for category in categories {
            modelContext.container.mainContext.delete(category)
        }
    }
    
    private func addItem() {
        withAnimation {
//            let newItem = Item(timestamp: Date())
//            modelContext.insert(newItem)
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
    private func getLoadSeedDataToolbarItem() -> some ToolbarContent {
        let seedData = SeedData(modelContext: modelContext)
        
        return ToolbarItem {
            Button(action: seedData.loadSeedData) {
                Label("Load Seed Data", systemImage: "command")
            }
        }
    }

    private func getEditButtonToolbarItem() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            EditButton()
        }
    }

    private func getSortOrderToolbarItem() -> some ToolbarContent {
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
    
    private func getFilterToolbarItem() -> some ToolbarContent {
        ToolbarItem {
            Button {
                withAnimation {
                    checkboxState.toggleState()
//                    showHidden.toggle()
//                    checkboxState.state = .favorite
                }
            } label: {
                Image(systemName: "line.3.horizontal.decrease.circle")
            }
            .font(.title2)
//            .foregroundStyle(showHidden ? .blue : .red)
//            .foregroundColor(checkboxState.colorForState())
            .foregroundColor(colorForState(checkboxState.state))
        }
    }
    
    private func colorForState(_ state: CheckboxState) -> Color {
        switch state {
        case .none:
            return .blue
        case .hidden:
            return .red
        case .favorite:
            return .yellow
        }
    }
    
    private func getSettingsToolbarItem() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            NavigationLink(destination: SettingsView()) {
                Image(systemName: "gear")
            }
        }
    }
    
    private func getDeleteAllToolbarItem() -> some ToolbarContent {
        ToolbarItem {
            Button(action: deleteAll) {
                Label("Delete All", systemImage: "exclamationmark.warninglight.fill")
            }
        }
    }

    private func getAddItemToolbarItem() -> some ToolbarContent {
        ToolbarItem {
            Button(action: addItem) {
                Label("Add Item", systemImage: "plus")
            }
        }
    }
}

//#Preview {
//    @Environment(\.modelContext) var modelContext
////    @EnvironmentObject var checkboxState: SharedCheckboxState
//    
////    @StateObject var checkboxState = SharedCheckboxState()
//    
//    let previewHelper = PreviewHelper()
//    previewHelper.loadSampleData()
//    
//    return ContentView()
//        .modelContainer(previewHelper.container)
//        .environmentObject(SharedCheckboxState())
//    
//}
//
//
