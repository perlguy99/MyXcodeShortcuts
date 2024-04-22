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
    
    @Query private var categories: [Category]
    @Bindable var category: Category
    
    var body: some View {
        Form {
            Section("Category Name") {
                VStack {
                    TextField("Category Name", text: $category.name)
                        .padding(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 2)
                        )
                        .padding(.bottom, 20)
                 
                    List {
                        ForEach(categories) { category in
                            
                            Divider()
                            
                            HStack {
                                
                                Text(category.name)
                                Spacer()
                                Text("\(category.shortcuts.count)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding([.leading, .trailing])
                            
                        }
                        
                    }
                }
            }
        }
        .navigationTitle("Edit Category")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Category.self, configurations: config)
        
        let previewHelper = PreviewHelper(container: container)
        previewHelper.loadSampleData()
        
        return EditCategoryView(category: previewHelper.previewCategory)
            .modelContainer(container)
    } catch {
        return Text("Failed to create a model container")
    }
}
