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
        NavigationView {
            Form {
                categoryTextField
                categoryListOrMessage
                Spacer()
            }
            .navigationTitle("Categories")
            .onSubmit(handleSubmit)
        }
    }
    
    private var categoryTextField: some View {
        TextField(textFieldPlaceholder, text: $tempCategoryName)
            .textFieldStyle(.roundedBorder)
            .padding(.bottom, 20)
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
        List(categories, id: \.self) { category in
            CategoryRow(category: category)
                .onTapGesture {
                    setCategoryAndDismiss(category)
                }
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
        
        return CategorySelectionView(shortcut: previewHelper.previewShortcut)
            .modelContainer(container)
    } catch {
        return Text("Failed to create a model container")
    }
    
}
