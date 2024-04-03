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

    @Query var menuSections: [Category]

    @Binding var navigationPath: NavigationPath
    @Bindable var shortcut: Shortcut
    
    @State private var sectionName: String = ""
    @State private var selectedOption = "other"
    
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
                } header: {
                    Text("Keyboard Shortcut")
                } footer: {
                    Text("Hides shortcut from printing")
                }
                
                Section("Menu Location") {
                    Picker("Menu Section", selection: $shortcut.category) {
                        Text("Unknown")
                            .tag(Optional<Category>.none)
                        
                        if menuSections.isEmpty == false {
                            Divider()
                            
                            ForEach(menuSections) { section in
                                Text(section.name)
                                    .tag(Optional(section))
                            }
                        }
                    }
                    
                    Button("Add New Section", action: addSection)
                }
            }
        }
        
    }
    
    func addSection() {
        let menuSection = Category(name: "")
        modelContext.insert(menuSection)
        navigationPath.append(menuSection)
        print("Add Section")
    }
}

#Preview {
    @Environment(\.modelContext) var modelContext
    let previewHelper = PreviewHelper()

    do {
        var previewHelper = try PreviewHelper()
//        previewHelper.loadSeedData()
        
        return EditShortcutView(navigationPath: .constant(NavigationPath()), shortcut: previewHelper.previewShortcut)
        .modelContainer(previewHelper.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }

}
