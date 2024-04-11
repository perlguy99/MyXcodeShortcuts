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
    @AppStorage(Constants.Keys.showSymbols.rawValue) var showSymbols: Bool = true
    @AppStorage(Constants.Keys.statusInt.rawValue) var statusInt: Int = 0
    
    var body: some View {
        Section(header: Text(category.name).textCase(nil)) {
            ForEach(category.shortcuts.filter { shortcut in
                switch Status(rawValue: statusInt) {
                case .none:
                    return true
                case .favorite:
                    return shortcut.status == .favorite
                case .hidden:
                    return shortcut.status != .hidden
                }
            }) { shortcut in
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
                modelContext.delete(category.shortcuts[index])
            }
        }
    }
}

#Preview {
    @AppStorage(Constants.Keys.showSymbols.rawValue) var showSymbols: Bool = true
    
    let previewHelper = PreviewHelper()
    previewHelper.loadSampleData()
    
    return Group {
        CategoryView(navigationPath: .constant(NavigationPath()), category: previewHelper.previewCategory)
        
//        Spacer()
//        CategoryView(category: previewHelper.previewCategory, showSymbols: false)
//            .modelContainer(previewHelper.container)
    }
}
