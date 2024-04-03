//
//  CategoryView.swift
//  MyXcodeShortcuts
//
//  Created by Brent Michalski on 4/1/24.
//

import SwiftUI
import SwiftData

struct CategoryView: View {
    @Environment(\.modelContext) var modelContext
    
    var category: Category
    @AppStorage(Constants.Keys.showHidden.rawValue) var showHidden: Bool = true
    @AppStorage(Constants.Keys.showSymbols.rawValue) var showSymbols: Bool = true
    
    var body: some View {
        Section(header: Text(category.name).textCase(nil)) {
            ForEach(category.shortcuts?.filter { showHidden || $0.buttonState != .hidden } ?? []) { shortcut in
                ShortcutView(shortcut: shortcut, showSymbols: showSymbols)
            }
        }
        .foregroundColor(.red)
        .font(.headline)
        .bold()
    }
}

#Preview {
    @AppStorage(Constants.Keys.showHidden.rawValue) var showHidden: Bool = true
    @AppStorage(Constants.Keys.showSymbols.rawValue) var showSymbols: Bool = true
    
    let previewHelper = PreviewHelper()
    
    return Group {
        CategoryView(category: previewHelper.previewCategory, showHidden: true)
            .modelContainer(previewHelper.container)
        Spacer()
        CategoryView(category: previewHelper.previewCategory, showHidden: false, showSymbols: false)
            .modelContainer(previewHelper.container)
    }
}
