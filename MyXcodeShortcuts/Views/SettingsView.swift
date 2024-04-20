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
    
    @AppStorage(Constants.Keys.pdfTitle.rawValue) private var pdfTitle = Constants.defaultTitle
    @AppStorage(Constants.Keys.separator.rawValue) private var separator = Constants.defaultSeparator
    @AppStorage(Constants.Keys.showSymbols.rawValue) private var showSymbols = Constants.defaultShowSymbols
//    @AppStorage(Constants.Keys.statusInt.rawValue) var statusInt: Int = 0
    
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
    
//    var currentStatus: Status
//    
//    init(
//        pdfTitle: String = Constants.defaultTitle,
//        separator: String = Constants.defaultSeparator,
//        showSymbols: Bool = Constants.defaultShowSymbols,
//        showingValidationError: Bool = false,
//        example: String = "CMD CTRL OPT SHIFT RETURN X"
//    ) {
//        self.pdfTitle = pdfTitle
//        self.separator = separator
//        self.showSymbols = showSymbols
//        self.showingValidationError = showingValidationError
//        self.example = example
//        
////        self.currentStatus = Status(rawValue: statusInt)
//    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Custom PDF Title")) {
                    TextField("PDF Title", text: $pdfTitle)
                }

                Section(header: Text("Show Symbols")) {
                    Toggle(isOn: $showSymbols, label: {
                        Text("Show Symbols")
                    })
                }

                Section(header: Text("Custom Key Separator")) {
                    
                    HStack {
                        Spacer()
                        
                        let keyCombo = showSymbols ? example.replacingKeywordsWithSymbols(separator: separator) :
                        example.replacingKeywordsWithFullWords(separator: separator)
                        
                        Text(keyCombo)
                            .transition(.opacity)
                            .animation(.default, value: separator)
                            .font(.largeTitle)
                        Spacer()
                    }
                    
                    Picker("Custom Separator", selection: $separator) {
                        ForEach(Separator.allCases, id: \.self) { option in
                            Text("\(option.description)").tag(option.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section(header: Text("Preview/Print PDF Cheatsheet")) {
                    let creator = PDFGenerator(categories: categories)
                    let renderedPDF = creator.renderDocument()
                    
                    if let renderedPDF = renderedPDF {
                        if let pdfData = renderedPDF.dataRepresentation() {
                            NavigationLink(destination: PDFPreviewView(data: pdfData)) {
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
    return SettingsView()
}


