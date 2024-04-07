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
    @Binding var navigationPath: NavigationPath
    
    var category: Category
    @AppStorage(Constants.Keys.showHidden.rawValue) var showHidden: Bool = true
    @AppStorage(Constants.Keys.showSymbols.rawValue) var showSymbols: Bool = true
    
    var body: some View {
        Section(header: Text(category.name).textCase(nil)) {
            ForEach(category.shortcuts?.filter { showHidden || $0.buttonState != .hidden } ?? []) { shortcut in
                ShortcutView(navigationPath: $navigationPath, shortcut: shortcut, showSymbols: showSymbols)
            }
            .onDelete(perform: deleteShortcuts)
        }
        .foregroundColor(.red)
        .font(.headline)
        .bold()
    }
    
    private func deleteShortcuts(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                guard let shortcuts = category.shortcuts else { return }
                modelContext.delete(shortcuts[index])
            }
        }
    }
}

#Preview {
    @AppStorage(Constants.Keys.showHidden.rawValue) var showHidden: Bool = true
    @AppStorage(Constants.Keys.showSymbols.rawValue) var showSymbols: Bool = true
    
    let previewHelper = PreviewHelper()
    previewHelper.loadSampleData()
    
    return Group {
        CategoryView(navigationPath: .constant(NavigationPath()), category: previewHelper.previewCategory)
        Spacer()
//        CategoryView(category: previewHelper.previewCategory, showHidden: false, showSymbols: false)
//            .modelContainer(previewHelper.container)
    }
}
