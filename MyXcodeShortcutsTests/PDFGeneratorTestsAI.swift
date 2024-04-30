////
////  PDFGeneratorTestsAI.swift
////  MyXcodeShortcutsTests
////
////  Created by Brent Michalski on 4/25/24.
////
//
//import XCTest
//@testable import MyXcodeShortcuts
//
//class PDFGeneratorTestsAI: XCTestCase {
//    var pdfGenerator: PDFGenerator!
//    var mockStatusManager: MockStatusManager!
//    
//    override func setUp() {
//        super.setUp()
//        mockStatusManager = MockStatusManager()
//        pdfGenerator = PDFGenerator(categories: [Category(name: "Test", shortcuts: [Shortcut(details: "This is a very long detail that should wrap correctly", convertedWithSymbols: "Cmd + Shift + S")])], statusManager: mockStatusManager)
//    }
//    
//    override func tearDown() {
//        pdfGenerator = nil
//        mockStatusManager = nil
//        super.tearDown()
//    }
//    
//    func testTextWrapping() {
//        let expectedWidth = pdfGenerator.PDFSize.width * 0.5 - (pdfGenerator.margin * 2)
//        
//        UIGraphicsBeginImageContext(CGSize(width: expectedWidth, height: 100))
//        let context = UIGraphicsGetCurrentContext()
//        
//        // Render the categories and intercept the drawing to the context
//        context?.saveGState()
//        pdfGenerator.renderCategories()
//        context?.restoreGState()
//        
//        let drawnImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        
//        XCTAssertNotNil(drawnImage)
//        
//        // Check if the text is within bounds
//        let renderedTextSize = drawnImage?.size
//        XCTAssertTrue(renderedTextSize?.width ?? 0 <= expectedWidth)
//    }
//    
//    func testColumnAndPageTransitions() {
//        let shortcuts = (1...100).map { _ in Shortcut(details: "Detail", convertedWithSymbols: "Cmd + S") }
//        pdfGenerator.categories = [Category(name: "Test Large", shortcuts: shortcuts)]
//        
//        pdfGenerator.createPDF()
//        
//        // Assuming pdfDocument is updated within createPDF
//        let pageCount = pdfGenerator.pdfDocument.pageCount
//        let expectedPageCount = (shortcuts.count / Int((pdfGenerator.PDFSize.height - pdfGenerator.topMargin) / pdfGenerator.lineHeight)) / 2
//        
//        XCTAssertGreaterThanOrEqual(pageCount, expectedPageCount, "Page count should be at least \(expectedPageCount)")
//    }
//
//    
//
//}
