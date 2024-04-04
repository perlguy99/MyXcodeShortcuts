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
    @EnvironmentObject var checkboxState: SharedCheckboxState
    
    var category: Category
    let viewModel: ViewModel
    
//    var checkboxState: SharedCheckboxState = SharedCheckboxState()
    
    init(category: Category) {
        self.category = category
        self.viewModel = CategoryView.ViewModel(category: category)

        checkboxState.state = .favorite
        
    }
    
    @AppStorage(Constants.Keys.showHidden.rawValue) var showHidden: Bool = true
    @AppStorage(Constants.Keys.showSymbols.rawValue) var showSymbols: Bool = true
    
    var body: some View {
        Section(header: Text(category.name).textCase(nil)) {
            
            ForEach(category.filteredShortcuts(filterValue: checkboxState.state) ?? []) { shortcut in
                ShortcutView(shortcut: shortcut, showSymbols: showSymbols)
            }
            
            ForEach(category.shortcuts?.filter { showHidden || $0.buttonState != .hidden } ?? []) { shortcut in
                ShortcutView(shortcut: shortcut, showSymbols: showSymbols)
            }
        }
        .foregroundColor(.red)
        .font(.headline)
        .bold()
    }
}

extension CategoryView {
    class ViewModel {
        var category: Category
        
        init(category: Category) {
            self.category = category
        }
    }
}

#Preview {
    @AppStorage(Constants.Keys.showHidden.rawValue) var showHidden: Bool = true
    @AppStorage(Constants.Keys.showSymbols.rawValue) var showSymbols: Bool = true
    
//    @EnvironmentObject var checkboxState: SharedCheckboxState
    
    let previewHelper = PreviewHelper()
    previewHelper.loadSampleData()
    
    return Group {
        CategoryView(category: previewHelper.previewCategory)
            .modelContainer(previewHelper.container)
//            .environmentObject(SharedCheckboxState())
        Spacer()
        CategoryView(category: previewHelper.previewCategory)
            .modelContainer(previewHelper.container)
//            .environmentObject(SharedCheckboxState())
    }
    .environmentObject(SharedCheckboxState())
}
