//
//  PDFPreviewView.swift
//  MyXcodeShortcuts
//
//  Created by Brent Michalski on 4/10/24.
//

import SwiftUI
import PDFKit

struct PDFPreviewView: View {
    let statusManager: StatusManager
    let data: Data

    init(data: Data, statusManager: StatusManager) {
        self.data = data
        self.statusManager = statusManager
    }
    
    var body: some View {
        VStack {
            Button(action: {
                printPDFDirectly(pdfData: data)
            }, label: {
                HStack {
                    Text("Print PDF")
                    Image(systemName: "printer")
                }
            })
            .padding()

            PDFViewUI(data: data)
            
            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func printPDFDirectly(pdfData: Data) {
        let printController = UIPrintInteractionController.shared
        
        if UIPrintInteractionController.canPrint(pdfData) {
            let printInfo = UIPrintInfo(dictionary: nil)
            printInfo.jobName = statusManager.pdfTitle
            printInfo.outputType = .general
            
            printController.printInfo = printInfo
            printController.printingItem = pdfData

            printController.present(animated: true) { (_, isPrinted, error) in
                if !isPrinted {
                    if let error = error {
                        print("Failed to print: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}

struct PDFViewUI: UIViewRepresentable {
    let data: Data
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(data: data)
        return pdfView
    }
    
    func updateUIView(_ uiView: PDFView, context: Context) {
        // update if needed
    }
}

#Preview {
    let statusManager = StatusManager()
    
    return PDFPreviewView(data: "PDF Data".data(using: .utf8)!, statusManager: statusManager)
}


