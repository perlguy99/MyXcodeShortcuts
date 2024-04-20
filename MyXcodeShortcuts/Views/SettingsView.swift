//
//  SettingsView.swift
//  MyXcodeShortcuts
//
//  Created by Brent Michalski on 4/1/24.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var statusManager: StatusManager
    
    @Query private var categories: [Category]
    
    @State private var showingValidationError = false
    
    let separatorOptions = [" ", "-", ".", "~", "+"]
    let separatorStrings = ["SPACE", "DASH", "DOT", "TILDE", "PLUS"]
    
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

    var example = "CMD CTRL OPT SHIFT RETURN X"
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Custom PDF Title")) {
                    TextField("PDF Title", text: $statusManager.pdfTitle)
                }

                Section(header: Text("Show Symbols")) {
                    Toggle(isOn: $statusManager.showSymbols, label: {
                        Text("Show Symbols")
                    })
                }

                Section(header: Text("Custom Key Separator")) {
                    
                    HStack {
                        Spacer()
                        
                        let keyCombo = statusManager.showSymbols ? example.replacingKeywordsWithSymbols(separator: statusManager.separator) :
                        example.replacingKeywordsWithFullWords(separator: statusManager.separator)
                        
                        Text(keyCombo)
                            .transition(.opacity)
                            .animation(.default, value: statusManager.separator)
                            .font(.largeTitle)
                        Spacer()
                    }
                    
                    Picker("Custom Separator", selection: $statusManager.separator) {
                        ForEach(Separator.allCases, id: \.self) { option in
                            Text("\(option.description)").tag(option.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section(header: Text("Preview/Print PDF Cheatsheet")) {
                    let creator = PDFGenerator(categories: categories, statusManager: statusManager)
                    let renderedPDF = creator.renderDocument()
                    
                    if let renderedPDF = renderedPDF {
                        if let pdfData = renderedPDF.dataRepresentation() {
                            NavigationLink(destination: PDFPreviewView(data: pdfData, statusManager: statusManager)) {
                                HStack {
                                    Image(systemName: "square.and.arrow.up")
                                    Text("Preview/Print PDF Cheatsheet")
                                }
                            }
                        }
                    }
                }

                if showingValidationError {
                    Section {
                        Text("Error: PDF Title cannot be empty.").foregroundColor(.red)
                    }
                }
            }
            .navigationBarTitle("Settings", displayMode: .inline)
        }
    }
}

#Preview {
    do {
        let statusManager = StatusManager(userDefaults: UserDefaults.previewUserDefaults())
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Category.self, configurations: config)
        
            return SettingsView()
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
        
        statusManager.showSymbols = true

        return SettingsView()
            .modelContainer(container)
            .environmentObject(statusManager)
    } catch {
        return Text("Failed to create a model container")
    }
}

