//
//  CategoryListView.swift
//  MyXcodeShortcuts
//
//  Created by Brent Michalski on 4/1/24.
//

import SwiftUI
import SwiftData

struct CategoryListView: View {
    /// The `ShortcutApp.id` of the currently active collection. When set, only categories
    /// belonging to that collection are shown; when `nil`, all categories are shown (matches
    /// prior behavior, used by previews that don't set up collections).
    var activeShortcutAppID: UUID?

    @Query(sort: [SortDescriptor(\Category.name, comparator: .localized)]) var categories: [Category]
    @Query(filter: #Predicate<Shortcut> { $0.category == nil }) var filteredShortcuts: [Shortcut]

    var visibleCategories: [Category] {
        guard let activeShortcutAppID else { return categories }
        return categories.filter { $0.shortcutApp?.id == activeShortcutAppID }
    }

    var body: some View {
        List {
            ForEach(visibleCategories) { category in
                CategoryView(category: category)
            }

            if filteredShortcuts.isNotEmpty {
                Section(header: Text("Uncategorized").textCase(nil)) {
                    ForEach(filteredShortcuts) { shortcut in
                        ShortcutView(shortcut: shortcut)
                    }
                }
                .foregroundStyle(ThemeManager.categoryHeaderTextColor)
                .font(.headline)
                .bold()
            }
        }
    }

    init(sortOrder: [SortDescriptor<Category>] = [], activeShortcutAppID: UUID? = nil) {
        _categories = Query(sort: sortOrder)
        self.activeShortcutAppID = activeShortcutAppID
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
        
        return CategoryListView()
            .modelContainer(container)
            .environment(statusManager)
    } catch {
        return Text("Failed to create a model container")
    }
}
