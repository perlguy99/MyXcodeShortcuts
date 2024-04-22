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
    @EnvironmentObject var statusManager: StatusManager
    
    @Binding var navigationPath: NavigationPath
    
    @Query(sort: [SortDescriptor(\Category.name, comparator: .localized)]) var categories: [Category]
    
    var body: some View {
        List {
            ForEach(categories) { category in
                CategoryView(navigationPath: $navigationPath, category: category)
            }
        }
    }
    
    init(navigationPath: Binding<NavigationPath>, sortOrder: [SortDescriptor<Category>] = []) {
        _navigationPath = navigationPath
        _categories = Query(sort: sortOrder)
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
        
        return CategoryListView(navigationPath: .constant(NavigationPath()))
            .modelContainer(container)
            .environmentObject(statusManager)
    } catch {
        return Text("Failed to create a model container")
    }
}
