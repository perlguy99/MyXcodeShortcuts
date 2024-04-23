//
//  EditShortcutView.swift
//  MyXcodeShortcuts
//
//  Created by Brent Michalski on 4/1/24.
//

import SwiftUI
import SwiftData

struct EditShortcutView: View {
    @Environment(\.modelContext) var modelContext
    @Binding var navigationPath: NavigationPath

    @Bindable var shortcut: Shortcut
    
    @FocusState var isKeyComboFieldActive: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        TextField("Key Combination", text: $shortcut.keyCombo)
                            .textFieldStyle(.roundedBorder)
                            .focused($isKeyComboFieldActive)
                            .toolbar {
                                if isKeyComboFieldActive {
                                    ToolbarItemGroup(placement: .keyboard) {
                                        keyboardToolbar
                                    }
                                }
                            }
                        
                        Text(shortcut.convertedKeyCombo)
                        
                        TextField("Details", text: $shortcut.details)
                            .textFieldStyle(.roundedBorder)
                    } header: {
                        Text("Keyboard Shortcut")
                    } 
                    
                    Section("Category") {
                        NavigationLink(destination: CategorySelectionView(shortcut: shortcut)) {
                            Text(shortcut.category?.name ?? "Select a Category")
                        }
                    }
                }
            }
        }
        .navigationTitle("Edit Shortcut")
    }

    private var keyboardToolbar: some View {
        HStack {
            Spacer()
            ForEach(KeyData.all, id: \.self) { key in
                Button(action: {
                    appendKeyCombo(key: key.name)
                }) {
                    Text(key.symbol)
                }
                .buttonStyle(.plain)
                Spacer()
            }
        }
        .font(.system(size: 24))
    }
    
    private func appendKeyCombo(key: String) {
        shortcut.keyCombo += (shortcut.keyCombo.isEmpty ? "" : " ") + key
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Category.self, configurations: config)
        
        let previewHelper = PreviewHelper(container: container)
        previewHelper.loadSampleData()
        
        return EditShortcutView(navigationPath: .constant(NavigationPath()), shortcut: previewHelper.previewShortcut)
            .modelContainer(container)
    } catch {
        return Text("Failed to create a model container")
    }

}
