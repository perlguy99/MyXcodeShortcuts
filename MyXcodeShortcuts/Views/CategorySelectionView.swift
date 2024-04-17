//
//  CategorySelectionView.swift
//  MyXcodeShortcuts
//
//  Created by Brent Michalski on 4/15/24.
//

import SwiftUI
import SwiftData

// TODO: When the view is presented, place a check on the row that is currently selected.

// TODO: There should be a TextField at the top that is blank with a placeholder

// TODO: that says "New Category"

// TODO: Then we should have a LIST of all categories and a COUNT of all shortcuts in that category

// TODO: Upon tapping a row - OR - having text in the TextField and hitting the "back" button

// TODO: the data should get updated in the database.

// TODO: Called by EditShortcutView

// TODO: It seems to make sense to just pass it in a Shortcut object, doesn't it?



struct CategorySelectionView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State var shortcut: Shortcut
    
    @Query private var categories: [Category]
    
    @State private var tempCategoryName: String = ""
    
    private let placeholder1 = "Category Name"
    private let placeholder2 = "Or, Enter New Category"
    
    var body: some View {
        
        NavigationView {
            Form {
                TextField(categories.isEmpty ? placeholder1 : placeholder2, text: $tempCategoryName)
                    .textFieldStyle(.roundedBorder)
                    .padding(.bottom, 20)
                
                if categories.isEmpty {
                    Text("No categories yet").italic()
                } else {
                    listCategories
                }
            }
            .navigationTitle("Categories")
            .onSubmit {
                insertNewCategoryAndStoreInShortcut(name: tempCategoryName)
                tempCategoryName = "" // Reset after addinng
                dismiss()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add") {
                        insertNewCategoryAndStoreInShortcut(name: tempCategoryName)
                        tempCategoryName = "" // Reset after addinng
                    }
                }
            }
        } // NavigationView
    }
    
    var listCategories: some View {
        
//        List(categories) { category in
//            CategoryRow(category: category)
//                .onTapGesture {
//                    setCategoryAndDismiss(category: category)
//                }
//        }
        
        List {
            ForEach(categories) { category in
                CategoryRow(category: category)
                    .onTapGesture {
                        setCategoryAndDismiss(category: category)
                    }
            }
            .onDelete(perform: deleteCategories)
        }
        
        
    }
    
    func deleteCategories(_ offsets: IndexSet) {
        for offset in offsets {
            let category = categories[offset]
            modelContext.delete(category)
        }
    }
    
    func insertNewCategoryAndStoreInShortcut(name: String) {
        guard name.isNotEmpty else { return }
        
        let newCategory = Category(name: name)
        modelContext.insert(newCategory)
        newCategory.shortcuts.append(shortcut)
        shortcut.category = newCategory
        dismiss()
    }
    
    func setCategoryAndDismiss(category: Category) {
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


struct CategoryRow: View {
    let category: Category
    
    var body: some View {
        HStack {
            Text(category.name)
            Spacer()
            Text("\(category.shortcuts.count)")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}
