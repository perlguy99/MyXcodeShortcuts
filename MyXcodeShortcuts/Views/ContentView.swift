//
//  ContentView.swift
//  MyXcodeShortcuts
//
//  Created by Brent Michalski on 4/1/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var searchText = ""
    @State private var navigationPath = NavigationPath()
    @State private var sortOrder = [SortDescriptor(\Category.name)]
    
    @Query private var categories: [Category]
    
    @AppStorage(Constants.Keys.showHidden.rawValue) var showHidden: Bool = true
    
    // TODO: - figure out toolbar item order if needed
    var body: some View {
        NavigationStack(path: $navigationPath) {
            CategoryListView(searchString: searchText, sortOrder: sortOrder)
                .navigationTitle("My Xcode Shortcuts")
                .navigationDestination(for: Shortcut.self) { shortcut in
                    EditShortcutView(navigationPath: $navigationPath, shortcut: shortcut)
                }
            
                .toolbar {
//                    getSortOrderToolbarItem()
                    getAddItemToolbarItem()
                    getFilterToolbarItem()
                    getSettingsToolbarItem()
//                    getEditButtonToolbarItem()
                    getDeleteAllToolbarItem()
                    getLoadSeedDataToolbarItem()
                }
                .searchable(text: $searchText)
        }
        
    }
    
    private func loadSeedData() {
        print("Load Seed Data")
    }
    
    private func deleteAll() {
        print("\n------------------------------")
        print("DELETING ALL DATA")
        print("------------------------------\n")

        modelContext.container.deleteAllData()
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

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        let previewHelper = PreviewHelper()
//                
//        ContentView()
//            .modelContainer(previewHelper.container)
//            .previewDevice(PreviewDevice(rawValue: "iPad Pro (12.9-inch) (6th generation)"))
//    }
//}


#Preview {
    let previewHelper = PreviewHelper()
    
    return ContentView()
        .modelContainer(previewHelper.container)
}


extension ContentView {
    
    private func getLoadSeedDataToolbarItem() -> some ToolbarContent {
        ToolbarItem {
            Button(action: loadSeedData) {
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
                    self.showHidden.toggle()
                }
            } label: {
                Image(systemName: "line.3.horizontal.decrease.circle")
            }
            .font(.title2)
            .foregroundStyle(self.showHidden ? .blue : .red)
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
