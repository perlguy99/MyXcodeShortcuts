//
//  ShortcutView.swift
//  MyXcodeShortcuts
//
//  Created by Brent Michalski on 4/1/24.
//

import SwiftUI
import SwiftData

struct ShortcutView: View {
    @Environment(\.modelContext) var modelContext
    @Binding var navigationPath: NavigationPath
    @Bindable var shortcut: Shortcut
    
    @AppStorage(Constants.Keys.separator.rawValue) var separator = Constants.defaultSeparator
    @AppStorage(Constants.Keys.showSymbols.rawValue) var showSymbols = Constants.defaultShowSymbols
    
    var body: some View {
        
        let keyCombo = showSymbols ? shortcut.keyCombo.replacingKeywordsWithSymbols(separator: separator) : shortcut.keyCombo.replacingKeywordsWithFullWords(separator: separator).lowercased()
        
        VStack {
            HStack {
                Spacer()
                VStack {
                    Text(shortcut.details)
                        .fontWeight(.light)
                        .foregroundStyle(Color(.black))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(keyCombo)
                        .bold()
                        .foregroundStyle(Color(.black))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Spacer()
                
                Checkbox(state: $shortcut.status)
                
                Spacer()
            }
        }
        .contentShape(Rectangle())
        .onTapGesture(perform: {})  // Needed or .onLongPressGesture blocks scrolling. :^/
        .onLongPressGesture(perform: handleLongPress)
    }
    
    func handleLongPress() {
        navigationPath.append(shortcut)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Category.self, configurations: config)
        
        let previewHelper = PreviewHelper(container: container)
        previewHelper.loadSampleData()
        
        return Group {
            ShortcutView(navigationPath: .constant(NavigationPath()), shortcut: previewHelper.previewNone, showSymbols: true)
            ShortcutView(navigationPath: .constant(NavigationPath()), shortcut: previewHelper.previewFavorite, showSymbols: false)
            ShortcutView(navigationPath: .constant(NavigationPath()), shortcut: previewHelper.previewHidden, showSymbols: true)
        }
        .modelContainer(previewHelper.container)
    } catch {
        return Text("Failed to create a model container")
    }
}
