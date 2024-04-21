//
//  PDFViewModel.swift
//  MyXcodeShortcuts
//
//  Created by Brent Michalski on 4/21/24.
//

import SwiftUI

class PDFViewModel: ObservableObject {
    @Published var pdfData: Data?
    var categories: [Category]
    var statusManager: StatusManager
    
    init(categories: [Category], statusManager: StatusManager) {
        self.categories = categories
        self.statusManager = statusManager
    }
    
    func generatePDF() {
        let creator = PDFGenerator(categories: categories, statusManager: statusManager)
        let renderedPDF = creator.renderDocument()
        self.pdfData = renderedPDF?.dataRepresentation()
    }
}

