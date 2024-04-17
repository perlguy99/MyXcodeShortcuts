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
                        
                        TextField("Details", text: $shortcut.details)
                            .textFieldStyle(.roundedBorder)
                    } header: {
                        Text("Keyboard Shortcut")
                    } 
                    
                    Section("Category") {
                        NavigationLink(shortcut.category?.name ?? "", destination: CategorySelectionView(shortcut: shortcut))
                    }
                    
//                    Section("Category2") {
//                        Picker("Menu Category", selection: $shortcut.category) {
//                            Text("Unknown")
//                                .tag(Optional<Category>.none)
//                            
//                            if categories.isEmpty == false {
//                                Divider()
//                                
//                                ForEach(categories) { section in
//                                    Text(section.name)
//                                        .tag(Optional(section))
//                                }
//                            }
//                        }
//                        
//                        Button("Add New Category", action: addCategory)
//                    }
                }
            }
        }
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
        print("\(key) appended")
    }

    func addCategory() {
        let category = Category(name: "")
        modelContext.insert(category)
        navigationPath.append(category)
        print("Add Category")
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
