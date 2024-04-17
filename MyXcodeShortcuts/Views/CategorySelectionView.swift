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
    
    @State private var shortcut: Shortcut
    
    
    var body: some View {
        Text("Hello, World!")
    }
    
    init(shortcut: Shortcut) {
        self.shortcut = shortcut
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
