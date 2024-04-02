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
    
    @Query(sort: [SortDescriptor(\Category.name, comparator: .localized)]) var categories: [Category]
    
    @AppStorage(Constants.Keys.showHidden.rawValue) var showHidden: Bool = true
    @AppStorage(Constants.Keys.showSymbols.rawValue) var showSymbols: Bool = true

    var body: some View {
        
        List {
            ForEach(categories) { category in
                CategoryView(category: category)
            }
            .onDelete(perform: deleteCategories)
        }
        
        
    }
    
    init(searchString: String = "", sortOrder: [SortDescriptor<Category>] = [], showHidden: Bool? = nil, showSymbols: Bool? = nil) {
        if let showHidden = showHidden {
            self.showHidden = showHidden
        }
        
        if let showSymbols = showSymbols {
            self.showSymbols = showSymbols
        }
        
        _categories = Query(filter: #Predicate {
            if searchString.isEmpty {
                return true
            } else {
                return (
                    $0.name.localizedStandardContains(searchString) ||
                    $0.shortcuts.contains {
                        $0.details.localizedStandardContains(searchString)
                    }
                )
            }
        }, sort: [SortDescriptor(\Category.name, comparator: .localized)])
    }
    
    private func deleteCategories(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(categories[index])
            }
        }
    }
}

#Preview {
    @AppStorage(Constants.Keys.showHidden.rawValue) var showHidden: Bool = true
    @AppStorage(Constants.Keys.showSymbols.rawValue) var showSymbols: Bool = true
    
    let previewHelper = PreviewHelper()
    showHidden = true
    
    return Group {
        CategoryListView()
    }
    .modelContainer(previewHelper.container)
}

#Preview {
    @AppStorage(Constants.Keys.showHidden.rawValue) var showHidden: Bool = true
    @AppStorage(Constants.Keys.showSymbols.rawValue) var showSymbols: Bool = true
    
    let previewHelper = PreviewHelper()
    showHidden = false
    
    return Group {
        CategoryListView()
    }
    .modelContainer(previewHelper.container)
}

