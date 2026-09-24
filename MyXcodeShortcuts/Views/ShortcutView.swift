//
//  ShortcutView.swift
//  MyXcodeShortcuts
//
//  Created by Brent Michalski on 4/1/24.
//

import SwiftUI
import SwiftData

struct ShortcutView: View {
    @Environment(StatusManager.self) private var statusManager

    @Bindable var shortcut: Shortcut
        
    var body: some View {
        HStack {
            NavigationLink(value: shortcut) {
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
                }
            }

            Checkbox(state: $shortcut.status)

            Spacer()
        }
        .swipeActions(edge: .trailing) {
            if shortcut.status == .hidden {
                Button {
                    shortcut.status = .none
                } label: {
                    Label("Unhide", systemImage: "eye")
                }
                .tint(ThemeManager.borderColor(for: .hidden))
            } else {
                Button {
                    shortcut.status = .hidden
                } label: {
                    Label("Hide", systemImage: "eye.slash")
                }
                .tint(ThemeManager.borderColor(for: .hidden))
            }
        }
    }

    var convertedKeyCombo: String {
        statusManager.keyCombination(from: shortcut.keyCombo)
    }
}

#Preview {
    let statusManager = StatusManager()
    statusManager.showSymbols = true
    
    let previewHelper = PreviewHelper()
    previewHelper.loadSampleData()
    
    return Group {
        ShortcutView(shortcut: previewHelper.previewNone)
        ShortcutView(shortcut: previewHelper.previewFavorite)
        ShortcutView(shortcut: previewHelper.previewHidden)
    }
    .environment(statusManager)
    .modelContainer(previewHelper.container)
}

#Preview {
    let statusManager = StatusManager()
    statusManager.showSymbols = true
    
    let previewHelper = PreviewHelper()
    previewHelper.loadSampleData()
    
    return Group {
        ShortcutView(shortcut: previewHelper.previewNone)
        ShortcutView(shortcut: previewHelper.previewFavorite)
        ShortcutView(shortcut: previewHelper.previewHidden)
    }
    .environment(statusManager)
    .preferredColorScheme(.dark)
    .modelContainer(previewHelper.container)
}
