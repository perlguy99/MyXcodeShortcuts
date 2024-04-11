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

    @Query var categories: [Category]
    
    @Bindable var shortcut: Shortcut
    
    @FocusState var isInputActive: Bool
    
    let options = ["printed", "hidden", "other"]
    
    var body: some View {
        
        VStack {
            Form {
                
                Section {
                    TextField("Key Combination", text: $shortcut.keyCombo)
                        .textFieldStyle(.roundedBorder)
                        .focused($isInputActive)
                    
                    TextField("Details", text: $shortcut.details)
                        .textFieldStyle(.roundedBorder)
                } header: {
                    Text("Keyboard Shortcut")
                } 
                
                Section("Category") {
                    Picker("Menu Category", selection: $shortcut.category) {
                        Text("Unknown")
                            .tag(Optional<Category>.none)
                        
                        if categories.isEmpty == false {
                            Divider()
                            
                            ForEach(categories) { section in
                                Text(section.name)
                                    .tag(Optional(section))
                            }
                        }
                    }
                    
                    Button("Add New Category", action: addCategory)
                }
            }
        }
        
    }
    
    func addCategory() {
        let category = Category(name: "")
        modelContext.insert(category)
        navigationPath.append(category)
        print("Add Category")
    }
}

#Preview {
    let previewHelper = PreviewHelper()

    return EditShortcutView(navigationPath: .constant(NavigationPath()), shortcut: previewHelper.previewShortcut)
        .modelContainer(previewHelper.container)
}
