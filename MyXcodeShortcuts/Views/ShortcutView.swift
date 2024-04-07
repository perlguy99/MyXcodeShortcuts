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

    @AppStorage(Constants.Keys.customSeparator.rawValue) var customSeparator = Constants.defaultSeparator
    @AppStorage(Constants.Keys.showSymbols.rawValue) var showSymbols = Constants.defaultShowSymbols
    
    var body: some View {
        
        let keyCombo = showSymbols ? shortcut.keyCombo.replacingKeywordsWithSymbols(separator: customSeparator) : shortcut.keyCombo.replacingKeywordsWithFullWords(separator: customSeparator)
        
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
                
                Checkbox(state: $shortcut.buttonState)
                
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

//#Preview("SizeThat FitsLayout", traits: .sizeThatFitsLayout) {
#Preview {
    let previewHelper = PreviewHelper()
   
    return Group {
        ShortcutView(navigationPath: .constant(NavigationPath()), shortcut: previewHelper.previewNone, showSymbols: true)
        ShortcutView(navigationPath: .constant(NavigationPath()), shortcut: previewHelper.previewFavorite, showSymbols: false)
        ShortcutView(navigationPath: .constant(NavigationPath()), shortcut: previewHelper.previewHidden, showSymbols: true)
        
    }
    .modelContainer(previewHelper.container)
}
