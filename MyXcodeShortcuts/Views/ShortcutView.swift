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
    @EnvironmentObject var statusManager: StatusManager
    
    @Binding var navigationPath: NavigationPath
    @Bindable var shortcut: Shortcut
        
    var body: some View {
        
        VStack {
            HStack {
                Spacer()
                VStack {
                    Text(shortcut.details)
                        .fontWeight(.light)
                        .foregroundStyle(ThemeManager.appSecondaryTextColor)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(convertedKeyCombo)
                        .bold()
                        .foregroundStyle(ThemeManager.appPrimaryTextColor)
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
    
    var convertedKeyCombo: String {
        return shortcut.convertedKeyCombo
    }
    
    func handleLongPress() {
        navigationPath.append(shortcut)
    }
}

#Preview {
    let statusManager = StatusManager()
    statusManager.showSymbols = true
    
    let previewHelper = PreviewHelper()
    previewHelper.loadSampleData()
    
    return Group {
        ShortcutView(navigationPath: .constant(NavigationPath()), shortcut: previewHelper.previewNone)
        ShortcutView(navigationPath: .constant(NavigationPath()), shortcut: previewHelper.previewFavorite)
        ShortcutView(navigationPath: .constant(NavigationPath()), shortcut: previewHelper.previewHidden)
    }
    .modelContainer(previewHelper.container)
    .environmentObject(statusManager)
}

#Preview {
    let statusManager = StatusManager()
    statusManager.showSymbols = true
    
    let previewHelper = PreviewHelper()
    previewHelper.loadSampleData()
    
    return Group {
        ShortcutView(navigationPath: .constant(NavigationPath()), shortcut: previewHelper.previewNone)
        ShortcutView(navigationPath: .constant(NavigationPath()), shortcut: previewHelper.previewFavorite)
        ShortcutView(navigationPath: .constant(NavigationPath()), shortcut: previewHelper.previewHidden)
    }
    .preferredColorScheme(.dark)
    .modelContainer(previewHelper.container)
    .environmentObject(statusManager)
}
