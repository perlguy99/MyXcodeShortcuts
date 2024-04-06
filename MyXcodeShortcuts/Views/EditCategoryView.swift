//
//  EditCategoryView.swift
//  MyXcodeShortcuts
//
//  Created by Brent Michalski on 4/5/24.
//

import SwiftUI
import SwiftData

struct EditCategoryView: View {
    @Environment(\.modelContext) var modelContext
//    @Binding var navigationPath: NavigationPath
    
    @Bindable var category: Category
    
    var body: some View {
        
            Form {
                Section("Category Name") {
                    TextField("Category Name", text: $category.name)
                        .padding(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 2)
                        )
                }
            }
            .navigationTitle("Edit Category Name")
            .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    do {
        let previewHelper = try PreviewHelper()
        
        let menuSection = Category(name: "")
        
        return EditCategoryView(category: previewHelper.previewCategory)
            .modelContainer(previewHelper.container)
        
//        return EditCategoryView(categories: menuSection)
//            .modelContainer(previewHelper.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }

}

