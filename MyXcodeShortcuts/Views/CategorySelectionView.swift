//
//  CategorySelectionView.swift
//  MyXcodeShortcuts
//
//  Created by Brent Michalski on 4/15/24.
//

import SwiftUI
import SwiftData

struct CategorySelectionView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State var shortcut: Shortcut
    @Query private var categories: [Category]
    @State private var tempCategoryName: String = ""
    
    var body: some View {
        Form {
            TextField(textFieldPlaceholder, text: $tempCategoryName)
                .textFieldStyle(.roundedBorder)
                .padding(.bottom, 20)

            categoryListOrMessage
            
            Spacer()
        }
        .navigationTitle("Categories")
        .onSubmit(handleSubmit)
    }
    
    private var textFieldPlaceholder: String {
        categories.isEmpty ? "Category Name" : "Or, Enter New Category"
    }
    
    private var categoryListOrMessage: some View {
        Group {
            if categories.isEmpty {
                Text("No categories yet!").italic()
            } else {
                categoryList
            }
        }
    }
    
    private var categoryList: some View {
        List {
            ForEach(categories) { category in
                CategoryRow(category: category)
                    .onTapGesture {
                        setCategoryAndDismiss(category)
                    }
            }
            .onDelete(perform: deleteCategories)
        }
    }
    
    private func handleSubmit() {
        if tempCategoryName.isNotEmpty {
            insertNewCategoryAndStoreInShortcut()
        }
        dismiss()
    }
    
    func deleteCategories(_ offsets: IndexSet) {
        offsets.forEach { modelContext.delete(categories[$0]) }
    }
    
    func insertNewCategoryAndStoreInShortcut() {
        let newCategory = Category(name: tempCategoryName)
        modelContext.insert(newCategory)
        newCategory.shortcuts.append(shortcut)
        shortcut.category = newCategory
    }
    
    func setCategoryAndDismiss(_ category: Category) {
        shortcut.category = category
        dismiss()
    }
}


#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Category.self, configurations: config)
        
        let previewHelper = PreviewHelper(container: container)
        previewHelper.loadSampleData()
        
        let sampleCategories = [
            Category(name: "Category1"),
            Category(name: "Category2"),
            Category(name: "Category3"),
            Category(name: "Category4")
        ]
        
        for category in sampleCategories {
            container.mainContext.insert(category)
        }
        
        return CategorySelectionView(shortcut: previewHelper.previewShortcut)
            .modelContainer(container)
    } catch {
        return Text("Failed to create a model container")
    }
    
}
