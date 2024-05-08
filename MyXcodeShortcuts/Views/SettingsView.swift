//
//  SettingsView.swift
//  MyXcodeShortcuts
//
//  Created by Brent Michalski on 4/1/24.
//

import SwiftUI
import SwiftData

enum Separator: String, CaseIterable {
    case space = " "
    case dash = "-"
    case dot = "."
    case tilde = "~"
    case plus = "+"
    
    var description: String {
        switch self {
            case .space: return "SPACE"
            case .dash: return "DASH"
            case .dot: return "DOT"
            case .tilde: return "TILDE"
            case .plus: return "PLUS"
        }
    }
}

struct SettingsView: View {
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var statusManager: StatusManager
    
    @ObservedObject var pdfViewModel: PDFViewModel
    
    @Query private var categories: [Category]
    @State private var showingValidationError = false
    
    let separatorOptions = Separator.allCases
    
    var body: some View {
        SettingsFormView(pdfViewModel: pdfViewModel)
        .navigationBarTitleDisplayMode(.inline)
    }
}


struct SettingsBlankView: View {
    var body: some View {
        Text("Settings")
            .font(.headline)
    }
}

struct SettingsFormView: View {
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var statusManager: StatusManager
    @ObservedObject var pdfViewModel: PDFViewModel
    
    let separatorOptions = Separator.allCases
    
    var body: some View {
        Form {
            Section(header: Text("PDF Title")) {
                TextField("PDF Title", text: $statusManager.pdfTitle)
            }
            Section(header: Text("Show Symbols")) {
                Toggle("Show Symbols", isOn: $statusManager.showSymbols)
            }
            
            Section(header: Text("Key Separator")) {
                KeyCombinationView(combination: statusManager.keyCombination(from: "CMD CTRL OPT SHIFT RETURN X"))
                KeyCombinationView(combination: statusManager.keyCombination(from: "UpArrow DownArrow RightArrow LeftArrow tab X"))
                SeparatorPickerView(selectedSeparator: $statusManager.separator, separators: separatorOptions)
            }
            
            Section(header: Text("Preview/Print PDF Cheatsheet")) {
                Button("Preview/Print PDF Cheatsheet") {
                    pdfViewModel.generatePDF()
                }
                
                if let pdfData = pdfViewModel.pdfData {
                    NavigationLink(destination: PDFPreviewView(data: pdfData, statusManager: statusManager)) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                            Text("View Generated PDF")
                        }
                    }
                }
            }
            
            Section(header: Text("Help")) {
                NavigationLink("Help", destination: HelpView())
            }
        }
        .navigationBarTitle("Settings", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Text("Copyright © 2024, Brent Danger Michalski")
                    .font(.caption)
            }
        }
        
    }
}

struct KeyCombinationView: View {
    var combination: String
    
    var body: some View {
        HStack {
            Spacer()
            Text(combination)
                .transition(.opacity)
                .animation(.default, value: combination)
                .font(.largeTitle)
            Spacer()
        }
    }
}

struct SeparatorPickerView: View {
    @Binding var selectedSeparator: String
    let separators: [Separator]
    
    var body: some View {
        Picker("Custom Separator", selection: $selectedSeparator) {
            ForEach(separators, id: \.self) { option in
                Text(option.description).tag(option.rawValue)
            }
        }
        .pickerStyle(.segmented)
    }
}


#Preview {
    do {
        let statusManager = StatusManager(userDefaults: UserDefaults.previewUserDefaults())
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Category.self, configurations: config)
        let categories = [Category]()
        let pdfViewModel = PDFViewModel(categories: categories, statusManager: statusManager)
        
        return SettingsView(pdfViewModel: pdfViewModel)
            .modelContainer(container)
            .environmentObject(statusManager)
    } catch {
        return Text("Failed to create a model container")
    }
}

#Preview {
    do {
        let statusManager = StatusManager(userDefaults: UserDefaults.previewUserDefaults())
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Category.self, configurations: config)
        let categories = [Category]()
        let pdfViewModel = PDFViewModel(categories: categories, statusManager: statusManager)
        
        statusManager.showSymbols = true
        
        return SettingsView(pdfViewModel: pdfViewModel)
            .modelContainer(container)
            .environmentObject(statusManager)
    } catch {
        return Text("Failed to create a model container")
    }
}

#Preview {
    do {
        let statusManager = StatusManager(userDefaults: UserDefaults.previewUserDefaults())
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Category.self, configurations: config)
        let categories = [Category]()
        let pdfViewModel = PDFViewModel(categories: categories, statusManager: statusManager)
        
        statusManager.showSymbols = true
        
        return SettingsView(pdfViewModel: pdfViewModel)
            .preferredColorScheme(.dark)
            .modelContainer(container)
            .environmentObject(statusManager)
    } catch {
        return Text("Failed to create a model container")
    }
}
