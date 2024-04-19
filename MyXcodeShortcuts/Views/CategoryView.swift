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
    @Binding var navigationPath: NavigationPath
    
    var category: Category
    @AppStorage(Constants.Keys.showSymbols.rawValue) var showSymbols: Bool = true
    @AppStorage(Constants.Keys.statusInt.rawValue) var statusInt: Int = 0
    
    var filteredShortcuts: [Shortcut] {
        category.shortcuts.sorted { $0.details < $1.details }.filter { $0.matchesStatus(statusInt) }
    }
    
    var body: some View {
        Section(header: Text(category.name).textCase(nil)) {
            
            ForEach(filteredShortcuts) { shortcut in
                ShortcutView(navigationPath: $navigationPath, shortcut: shortcut, showSymbols: showSymbols)
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
    @AppStorage(Constants.Keys.showSymbols.rawValue) var showSymbols: Bool = true
    
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Category.self, configurations: config)
        
        let previewHelper = PreviewHelper(container: container)
        previewHelper.loadSampleData()
        
        return CategoryView(navigationPath: .constant(NavigationPath()), category: previewHelper.previewCategory)
            .modelContainer(container)
    } catch {
        return Text("Failed to create a model container")
    }
}
