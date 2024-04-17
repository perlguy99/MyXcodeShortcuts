//
//  CategoryListView.swift
//  MyXcodeShortcuts
//
//  Created by Brent Michalski on 4/1/24.
//

import SwiftUI
import SwiftData

struct CategoryListView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var navigationPath: NavigationPath
    
    @Query(sort: [SortDescriptor(\Category.name, comparator: .localized)]) var categories: [Category]
    
    @AppStorage(Constants.Keys.showSymbols.rawValue) var showSymbols: Bool = true

    var body: some View {
        
        List {
            ForEach(categories) { category in
                CategoryView(navigationPath: $navigationPath, category: category)
            }
        }
    }
    
    init(navigationPath: Binding<NavigationPath>, sortOrder: [SortDescriptor<Category>] = [], showSymbols: Bool? = nil) {
        if let showSymbols = showSymbols {
            self.showSymbols = showSymbols
        }
        
        _navigationPath = navigationPath
        _categories = Query(sort: sortOrder)
    }
}

#Preview {
    @AppStorage(Constants.Keys.showSymbols.rawValue) var showSymbols: Bool = true
    
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Category.self, configurations: config)
        
        let previewHelper = PreviewHelper(container: container)
        previewHelper.loadSampleData()
        
        return CategoryListView(navigationPath: .constant(NavigationPath()))
            .modelContainer(container)
    } catch {
        return Text("Failed to create a model container")
    }
}
