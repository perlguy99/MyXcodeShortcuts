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
    fileprivate let headerColor = UIColor(.appBaseBlue)
    fileprivate let textColor = UIColor(.appPrimaryText)
    fileprivate let PDFSize = CGSize(width: 612, height: 792)
    
    fileprivate var pageNumber: Int = 1
    fileprivate var column: CGFloat = 0
    fileprivate var firstPage = true
    
    fileprivate var documentPath: URL? {
        let fileManager = FileManager.default
        let documentsUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0] as URL
        return documentsUrl.appendingPathComponent("MyFavoriteShortcuts.pdf")
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
    
    func renderCategories() {
        let width = PDFSize.width * 0.5 - margin * 2
        var total = topMargin
        
        let categoryAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: headerColor]
        let bodyAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11), NSAttributedString.Key.foregroundColor: textColor]
        
        // Define background colors for alternating rows
        let normalBackgroundColor = UIColor(white: 1.0, alpha: 1.0) // White for normal rows
        let alternateBackgroundColor = UIColor(white: 0.95, alpha: 1.0) // Light gray for alternate rows
        
        for category in categories {
            let shortcuts = category.shortcuts.sorted { $0.details < $1.details }.filter { $0.matchesStatus(statusManager.currentStatus.intValue) }
            
            if shortcuts.isEmpty { continue }
            
            var xValue = margin + column * (width + margin + (column > 0 ? 20 : 0))
            
            if total + categoryLineHeight > PDFSize.height - bottomMargin {
                if column == 1 {
                    newPage()
                    xValue = margin
                } else {
                    column += 1
                    xValue = margin + column * (width + margin) + (column > 0 ? 20 : 0)
                }
                total = topMargin
            }
            
            let categoryName = "\(category.name) (\(shortcuts.count))"
            categoryName.draw(at: CGPoint(x: xValue, y: total), withAttributes: categoryAttributes)
            total += categoryLineHeight
            
            for (shortcutIndex, shortcut) in shortcuts.enumerated() {
                let keyCombo = shortcut.keyCombo.parseForControlCharacterMapping(returnType: statusManager.showSymbols ? .symbol : .long)
                let detailsWidth = (shortcut.details as NSString).size(withAttributes: bodyAttributes).width
                let detailsX = xValue + width - detailsWidth  // Right-align the details
                
                // Background color fill
                let backgroundColor = shortcutIndex % 2 == 0 ? normalBackgroundColor : alternateBackgroundColor
                let backgroundRect = CGRect(x: xValue, y: total, width: width, height: lineHeight)
                backgroundColor.setFill()
                UIRectFill(backgroundRect)
                
                // Draw key combo and details
                keyCombo.draw(at: CGPoint(x: xValue, y: total), withAttributes: bodyAttributes)
                let descriptionRect = CGRect(x: detailsX, y: total, width: detailsWidth, height: lineHeight)
                shortcut.details.draw(with: descriptionRect, options: .usesLineFragmentOrigin, attributes: bodyAttributes, context: nil)
                
                total += lineHeight
                
                if total > PDFSize.height - bottomMargin {
                    if column == 1 {
                        newPage()
                        xValue = margin
                    } else {
                        column += 1
                        xValue = margin + column * (width + margin) + (column > 0 ? 20 : 0)
                    }
                    total = topMargin
                    
                    let continuationText = "\(categoryName) (continued)"
                    continuationText.draw(at: CGPoint(x: xValue, y: total), withAttributes: categoryAttributes)
                    total += categoryLineHeight
                }
            }
        }
    }

    
    func renderCategoriesOld2() {
        let width = PDFSize.width * 0.5 - margin * 2
        var total = topMargin
        
        let categoryAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: headerColor]
        let bodyAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11), NSAttributedString.Key.foregroundColor: textColor]
        
        for category in categories {
            let shortcuts = category.shortcuts.sorted { $0.details < $1.details }.filter { $0.matchesStatus(statusManager.currentStatus.intValue) }
            
            if shortcuts.isEmpty { continue }
            
            var xValue = margin + column * (width + margin + (column > 0 ? 20 : 0))
            
            if total + categoryLineHeight > PDFSize.height - bottomMargin {
                if column == 1 {
                    newPage()
                    xValue = margin
                } else {
                    column += 1
                    xValue = margin + column * (width + margin) + (column > 0 ? 20 : 0)
                }
                total = topMargin
            }
            
            let categoryName = "\(category.name) (\(shortcuts.count))"
            categoryName.draw(at: CGPoint(x: xValue, y: total), withAttributes: categoryAttributes)
            total += categoryLineHeight
            
            for (shortcutIndex, shortcut) in shortcuts.enumerated() {
                let keyCombo = shortcut.keyCombo.parseForControlCharacterMapping(returnType: statusManager.showSymbols ? .symbol : .long)
                let keyComboSize = (keyCombo as NSString).size(withAttributes: bodyAttributes)
                keyCombo.draw(at: CGPoint(x: xValue, y: total), withAttributes: bodyAttributes)
                
                // Calculate right-aligned x position for details
                let detailsWidth = (shortcut.details as NSString).size(withAttributes: bodyAttributes).width
                let detailsX = xValue + width - detailsWidth  // Adjust to right-align the details
                
                let descriptionRect = CGRect(x: detailsX, y: total, width: detailsWidth, height: lineHeight)
                shortcut.details.draw(with: descriptionRect, options: .usesLineFragmentOrigin, attributes: bodyAttributes, context: nil)
                
                total += lineHeight
                
                if total > PDFSize.height - bottomMargin {
                    if column == 1 {
                        newPage()
                        xValue = margin
                    } else {
                        column += 1
                        xValue = margin + column * (width + margin) + (column > 0 ? 20 : 0)
                    }
                    total = topMargin
                    
                    let continuationText = "\(categoryName) (continued)"
                    continuationText.draw(at: CGPoint(x: xValue, y: total), withAttributes: categoryAttributes)
                    total += categoryLineHeight
                }
            }
        }
    }

    func renderCategoriesOld() {
        let width = PDFSize.width * 0.5 - margin * 2
        var total = topMargin
        
        let categoryAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: headerColor]
        let bodyAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11), NSAttributedString.Key.foregroundColor: textColor]
        
        // Define background colors for alternating rows
        let normalBackgroundColor = UIColor(white: 1.0, alpha: 1.0) // White for normal rows
        let alternateBackgroundColor = UIColor(white: 0.95, alpha: 1.0) // Light gray for alternate rows

        for category in categories {
            let shortcuts = category.shortcuts.sorted { $0.details < $1.details }.filter { $0.matchesStatus(statusManager.currentStatus.intValue) }
            
            if shortcuts.isEmpty { continue }
            
            // Adjust xValue calculation to include additional space from the center line
            var xValue = margin + column * (width + margin + (column > 0 ? 20 : 0))  // Add 20 points buffer for the right column
            
            // Check if new page or new column is needed
            if total + categoryLineHeight > PDFSize.height - bottomMargin {
                if column == 1 {  // Currently on right column, need new page
                    newPage()
                    xValue = margin  // Reset to left column
                } else {  // Currently on left column, switch to right
                    column += 1
                    xValue = margin + column * (width + margin) + (column > 0 ? 20 : 0)  // Add additional space when switching to right column
                }
                total = topMargin  // Reset vertical position
            }
            
            // Draw category name
            let categoryName = "\(category.name) (\(shortcuts.count))"
            categoryName.draw(at: CGPoint(x: xValue, y: total), withAttributes: categoryAttributes)
            total += categoryLineHeight
            
            for (shortcutIndex, shortcut) in shortcuts.enumerated() {
                let keyCombo = shortcut.keyCombo.parseForControlCharacterMapping(returnType: statusManager.showSymbols ? .symbol : .long)
                let keyComboSize = (keyCombo as NSString).size(withAttributes: bodyAttributes)
                
                // Prepare to draw key combo and description
                let descriptionWidth = width - keyComboSize.width - 10
                let descriptionRect = CGRect(x: xValue + keyComboSize.width + 10, y: total, width: descriptionWidth, height: lineHeight)
                
                // Set background color for row
                let backgroundColor = shortcutIndex % 2 == 0 ? normalBackgroundColor : alternateBackgroundColor
                let backgroundRect = CGRect(x: xValue, y: total, width: width, height: lineHeight)
                backgroundColor.setFill()
                UIRectFill(backgroundRect)
                
                // Draw key combo and shortcut description
                keyCombo.draw(at: CGPoint(x: xValue, y: total), withAttributes: bodyAttributes)
                shortcut.details.draw(with: descriptionRect, options: .usesLineFragmentOrigin, attributes: bodyAttributes, context: nil)
                
                total += lineHeight
                
                // Check if need to move to new column or page
                if total > PDFSize.height - bottomMargin {
                    if column == 1 {
                        newPage()
                        xValue = margin
                    } else {
                        column += 1
                        xValue = margin + column * (width + margin) + (column > 0 ? 20 : 0)  // Adjust xValue when wrapping to new column
                    }
                    total = topMargin
                    
                    // When starting new on a fresh column or page after wrapping, draw category continuation header
                    let continuationText = "\(categoryName) (continued)"
                    continuationText.draw(at: CGPoint(x: xValue, y: total), withAttributes: categoryAttributes)
                    total += categoryLineHeight
                }
            }
        }
    }

    
    func renderCategoriesOLD() {
        let width = PDFSize.width * 0.5
        let height = PDFSize.height - bottomMargin
        
        var total: CGFloat = topMargin
        
        let categoryAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: headerColor]
        let continuedAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: headerColor]
        let bodyAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11), NSAttributedString.Key.foregroundColor: textColor]
        
        for category in categories {
            let shortcuts = category.shortcuts.sorted { $0.details < $1.details }.filter { $0.matchesStatus(statusManager.currentStatus.intValue) }
            
            if shortcuts.isEmpty {
                continue
            }
            
            let name = category.name
            var xValue = margin + column * width
            
            // Ensure there's room for the category header
            if height - total < categoryLineHeight {
                column += 1
                
                if column > 1 {
                    newPage()
                    xValue = margin
                }
                total = topMargin
            }
            
            name.draw(at: CGPoint(x: xValue, y: total + 5), withAttributes: categoryAttributes)
            total += categoryLineHeight
            
            for shortcut in shortcuts {
                let keyCombo = shortcut.keyCombo.parseForControlCharacterMapping(returnType: statusManager.showSymbols ? .symbol : .long)
                let keyComboAttributes = NSAttributedString(string: keyCombo, attributes: bodyAttributes)
                let keyComboSize = keyComboAttributes.size()
                
                let descriptionWidth = width - (keyComboSize.width + 10)  // calculate the remaining width after the keyCombo
                let descriptionRect = CGRect(x: xValue + keyComboSize.width + 10, y: total, width: descriptionWidth, height: CGFloat.greatestFiniteMagnitude)
                
                if total + lineHeight < height {
                    keyComboAttributes.draw(at: CGPoint(x: xValue, y: total))
                    shortcut.details.draw(with: descriptionRect, options: .usesLineFragmentOrigin, context: nil)
                    total += lineHeight
                } else {
                    column += 1
                    
                    if column > 1 {
                        newPage()
                        xValue = margin
                    }
                    total = topMargin
                    
                    let text = "\(name) (continued)"
                    text.draw(at: CGPoint(x: xValue, y: total + 5), withAttributes: continuedAttributes)
                    total += categoryLineHeight
                    
                    keyComboAttributes.draw(at: CGPoint(x: xValue, y: total))
                    shortcut.details.draw(with: descriptionRect, options: .usesLineFragmentOrigin, context: nil)
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
        self.column = 0
        firstPage = false
    }
    
    fileprivate func renderHeader() {
        guard let logo = UIImage(named: "AppIcon") else { return }
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
        let line = UIBezierPath(rect: CGRect(x: 0, y: 0, width: PDFSize.width - 20, height: 3))
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
        textColor.setFill()
        line.fill()
    }
    
    fileprivate func printPageNumber() {
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),
                          NSAttributedString.Key.foregroundColor: textColor]
        let pageNumberString = "Page \(pageNumber)"
        pageNumberString.draw(at: CGPoint(x: PDFSize.width - 60, y: 60), withAttributes: attributes)
        pageNumber += 1
        
    }
}
