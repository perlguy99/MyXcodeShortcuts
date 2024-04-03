//
//  SettingsView.swift
//  MyXcodeShortcuts
//
//  Created by Brent Michalski on 4/1/24.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.modelContext) var modelContext
    
    @AppStorage(Constants.Keys.pdfTitle.rawValue) private var pdfTitle = Constants.defaultTitle
    @AppStorage(Constants.Keys.customSeparator.rawValue) private var customSeparator = Constants.defaultSeparator
    
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

    var example = "CMD CTRL OPT X"
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Custom PDF Title")) {
                    TextField("PDF Title", text: $pdfTitle)
                }

                Section(header: Text("Custom Key Separator")) {
                    
                    HStack {
                        Spacer()
                        Text( example.replacingKeywordsWithSymbols(separator: customSeparator))
                            .transition(.opacity)
                            .animation(.default, value: customSeparator)
                            .font(.largeTitle)
                        Spacer()
                    }
                    
                    Picker("Custom Separator", selection: $customSeparator) {
                        ForEach(Separator.allCases, id: \.self) { option in
                            Text("\(option.description)").tag(option.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
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
//    let previewHelper = PreviewHelper()

    return SettingsView()
}


