//
//  EditShortcutView.swift
//  MyXcodeShortcuts
//
//  Created by Brent Michalski on 4/1/24.
//

import SwiftUI
import SwiftData
import KeyboardKit

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
                    
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                HStack {
                                    Spacer()
                                    Button(Constants.cmdSymbol) {
                                        // append to $shortcut.keyCombo here
                                        shortcut.keyCombo += (shortcut.keyCombo.isEmpty ? "" : " ") + "cmd"
                                        
                                        print("cmd appended")
                                    }
                                    .font(.system(size: 24))
                                    .accessibilityHint("Command Key")
                                    
                                    Spacer()
                                    
                                    Button(Constants.ctrlSymbol) {
                                        // append to $shortcut.keyCombo here
                                        shortcut.keyCombo += (shortcut.keyCombo.isEmpty ? "" : " ") + "ctrl"
                                        
                                        print("ctrl appended")
                                    }
                                    .font(.system(size: 24))
                                    
                                    Spacer()
                                    
                                    Button(Constants.optSymbol) {
                                        // append to $shortcut.keyCombo here
                                        shortcut.keyCombo += (shortcut.keyCombo.isEmpty ? "" : " ") + "opt"
                                        
                                        print("opt appended")
                                    }
                                    .font(.system(size: 24))
                                    
                                    Spacer()
                                    
                                    Button(Constants.shiftSymbol) {
                                        // append to $shortcut.keyCombo here
                                        shortcut.keyCombo += (shortcut.keyCombo.isEmpty ? "" : " ") + "shift"
                                        
                                        print("shift appended")
                                    }
                                    .font(.system(size: 24))

                                    Spacer()
                                    
                                    Button(Constants.returnSymbol) {
                                        // append to $shortcut.keyCombo here
                                        shortcut.keyCombo += (shortcut.keyCombo.isEmpty ? "" : " ") + "return"
                                        
                                        print("return appended")
                                    }
                                    .font(.system(size: 24))
                                    
                                    Spacer()

                                }
                            }
                        }
                    
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
