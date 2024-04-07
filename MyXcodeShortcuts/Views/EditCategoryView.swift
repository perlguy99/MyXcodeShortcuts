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
            .navigationTitle("Edit Category")
            .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let previewHelper = PreviewHelper()
    
    return EditCategoryView(category: previewHelper.previewCategory)
        .modelContainer(previewHelper.container)
}

