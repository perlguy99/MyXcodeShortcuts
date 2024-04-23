//
//  PDFGenerator.swift
//  MyXcodeFaves
//
//  Created by Brent Michalski on 3/25/24.
//

import SwiftUI
import PDFKit

class PDFGenerator {
    var categories: [Category]
    
    // MARK: - PDF Formatting
    fileprivate let margin: CGFloat = 20
    fileprivate let topMargin: CGFloat = 100
    fileprivate let bottomMargin: CGFloat = 60
    fileprivate let lineHeight: CGFloat = 20
    fileprivate let categoryLineHeight: CGFloat = 30
    fileprivate let headerColor = UIColor(red: 0, green: 118/255, blue: 0, alpha: 1)
    fileprivate let PDFSize = CGSize(width: 612, height: 792)
    
    fileprivate var pageNumber: Int = 1
    fileprivate var column: CGFloat = 0
    fileprivate var firstPage = true
    
    fileprivate var documentPath: URL? {
        let fileManager = FileManager.default
        let documentsUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0] as URL
        return documentsUrl.appendingPathComponent("MyXcodeFavesShortcuts.pdf")
    }
    
    let statusManager: StatusManager
    
    var pdfDocument: PDFDocument = PDFDocument()
    
    init(categories: [Category], statusManager: StatusManager) {
        self.categories = categories
        self.statusManager = statusManager
    }
    
    func renderDocument() -> PDFDocument? {
        createPDF()
        
        if let url = documentPath {
            if let doc = PDFDocument(url: url) {
                pdfDocument = doc
            }
            return PDFDocument(url: url)
        }
        return nil
    }
    
    func createPDF() {
        guard let pdfPath = documentPath?.path else { return }
        UIGraphicsBeginPDFContextToFile(pdfPath, .zero, nil)
        newPage()
        renderCategories()
        UIGraphicsEndPDFContext()
    }
    
    fileprivate func renderCategories() {
        
        let width = PDFSize.width * 0.5
        let height = PDFSize.height - bottomMargin
        
        var total: CGFloat = topMargin
        
        let categoryAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: headerColor]
        let continuedAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: headerColor]
        let bodyAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11), NSAttributedString.Key.foregroundColor: UIColor.black]
        
        for category in categories {
            let shortcuts = category.shortcuts.sorted { $0.details < $1.details }.filter { $0.matchesStatus(statusManager.currentStatus.intValue) }
            
            if shortcuts.isEmpty {
                continue
            }
            
            let name = category.name
            
            // new page if not enough room to print item after section header
            if height - total < categoryLineHeight {
                column += 1
                total = topMargin
                if column > 1 {
                    newPage()
                }
            }
            
            var xValue = margin + column * width
            name.draw(at: CGPoint(x: xValue, y: total+5), withAttributes: categoryAttributes)
            total += categoryLineHeight
            
            for shortcut in shortcuts {
                let keyCombo = shortcut.convertedKeyCombo
                
                if total < height {
                    keyCombo.draw(at: CGPoint(x: xValue, y: total), withAttributes: bodyAttributes)
                    shortcut.details.draw(at: CGPoint(x: xValue + 100, y: total), withAttributes: bodyAttributes)
                    total += lineHeight
                } else {
                    column += 1
                    total = topMargin
                    if column > 1 {
                        newPage()
                    }
                    
                    xValue = margin + column * width
                    let text = "\(name) (continued)"
                    text.draw(at: CGPoint(x: xValue, y: total+5), withAttributes: continuedAttributes)
                    total += categoryLineHeight
                    keyCombo.draw(at: CGPoint(x: xValue, y: total), withAttributes: bodyAttributes)
                    shortcut.details.draw(at: CGPoint(x: xValue + 100, y: total), withAttributes: bodyAttributes)
                    total += lineHeight
                }
            }
        }
    }
    
    fileprivate func newPage() {
        UIGraphicsBeginPDFPage()
        renderHeader()
        renderFooter()
        renderCenterLine()
        printPageNumber()
        column = 0
    }
        
    fileprivate func renderHeader() {
        guard let logo = UIImage(named: "xcode-logo") else { return }
        let rect = CGRect(x: 10, y: 10, width: 70, height: 70)
        logo.draw(in: rect)
        
        let text = statusManager.pdfTitle
        let attributes: [NSAttributedString.Key : NSObject]
        if firstPage {
            attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20),
                          NSAttributedString.Key.foregroundColor: headerColor]
            firstPage = false
        } else {
            attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16),
                          NSAttributedString.Key.foregroundColor: headerColor]
        }
        text.draw(at: CGPoint(x: 100, y: 50), withAttributes: attributes)
        
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        context?.setShadow(offset: CGSize(width: 2, height: 2), blur: 5.0)
        let line = UIBezierPath(rect: CGRect(x: 0, y: 0, width: PDFSize.width-20, height: 3))
        let transform = CGAffineTransform(translationX: 10, y: 80)
        line.apply(transform)
        line.fill()
        context?.restoreGState()

    }

    fileprivate func renderFooter() {
        let leftText = "Inspired By: raywenderlich.com/Kodeco.com"
        let rightText = "©2024 Brent Michalski. All rights reserved"
        leftText.draw(at: CGPoint(x: margin, y: PDFSize.height - 20))
        rightText.draw(at: CGPoint(x: PDFSize.width - 250, y: PDFSize.height - 20))
    }

    fileprivate func renderCenterLine() {
        let line = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 0.5, height: PDFSize.height - topMargin - bottomMargin + 20))
        let transform = CGAffineTransform(translationX: PDFSize.width/2 , y: topMargin)
        line.apply(transform)
        UIColor.black.setFill()
        line.fill()
    }

    fileprivate func printPageNumber() {
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),
                          NSAttributedString.Key.foregroundColor: UIColor.black]
        let pageNumberString = "Page \(pageNumber)"
        pageNumberString.draw(at: CGPoint(x: PDFSize.width - 60, y: 60), withAttributes: attributes)
        pageNumber += 1

    }
}
