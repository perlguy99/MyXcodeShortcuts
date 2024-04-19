//
//  CategoryRow.swift
//  MyXcodeShortcuts
//
//  Created by Brent Michalski on 4/18/24.
//

import SwiftUI
import SwiftData

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

#Preview {
    
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Category.self, configurations: config)
        
        let previewHelper = PreviewHelper(container: container)
        previewHelper.loadSampleData()
        
        return CategoryRow(category: previewHelper.previewCategory)
            .modelContainer(container)
    } catch {
        return Text("Failed to create a model container")
    }
}
