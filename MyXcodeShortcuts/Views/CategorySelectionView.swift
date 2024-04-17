//
//  CategorySelectionView.swift
//  MyXcodeShortcuts
//
//  Created by Brent Michalski on 4/15/24.
//

import SwiftUI

// TODO: When the view is presented, place a check on the row that is currently selected.
// TODO: There should be a TextField at the top that is blank with a placeholder
// TODO: that says "New Category"
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


//#Preview {
//    let previewHelper = PreviewHelper()
//
//    return CategorySelectionView(shortcut: previewHelper.previewShortcut)
//        .modelContainer(previewHelper.container)
//}
