//
//  PDFGeneratorTests.swift
//  MyXcodeShortcutsTests
//
//  Created by Brent Michalski on 4/7/24.
//

import XCTest
import SwiftUI
import SwiftData

@testable import MyXcodeShortcuts

final class PDFGeneratorTests: XCTestCase {
    var statusManager: StatusManager!

    override func setUp() {
        super.setUp()
        
        statusManager = StatusManager()
        
        // Set to .none to start with
        statusManager.currentStatus = .none
        statusManager.pdfTitle = Constants.defaultTitle
        statusManager.separator = Constants.defaultSeparator
    }
    
    override func tearDown() {
        super.tearDown()
        
        statusManager.currentStatus = .none
        statusManager.pdfTitle = Constants.defaultTitle
        statusManager.separator = Constants.defaultSeparator
    }
    
    func testDefaultTitleWhenNoTitleSet() throws {
        XCTAssertEqual(statusManager.pdfTitle, Constants.defaultTitle, "\n\nExpected: \(Constants.defaultTitle)\nBut got: \(statusManager.pdfTitle)\n\n")
        XCTAssertEqual(statusManager.separator, Constants.defaultSeparator, "\n\nExpected: \(Constants.defaultSeparator)\nBut got: \(statusManager.separator)\n\n")
    }
    
    func testProperTitleWhenTitleSet() throws {
        let otherTitle = "OtHeR TiTlE"
        let otherSeparator = ""
        
        statusManager.pdfTitle = otherTitle
        statusManager.separator = otherSeparator
        
        XCTAssertEqual(statusManager.pdfTitle, otherTitle, "\n\nExpected: \(otherTitle)\nBut got: \(statusManager.pdfTitle)\n\n")
        XCTAssertEqual(statusManager.separator, otherSeparator, "\n\nExpected: \(otherSeparator)\nBut got: \(statusManager.separator)\n\n")
        
        // Double-check
        XCTAssertEqual(statusManager.pdfTitle, otherTitle, "\n\nExpected: \(otherTitle)\nBut got: \(statusManager.pdfTitle)\n\n")
        XCTAssertEqual(statusManager.separator, otherSeparator, "\n\nExpected: \(otherSeparator)\nBut got: \(statusManager.separator)\n\n")
    }
    
    @MainActor
    func testRenderDocument() throws {
        let sharedModelContainer: ModelContainer = {
            let schema = Schema([Category.self, Shortcut.self])
            
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

            do {
                return try ModelContainer(for: schema, configurations: [modelConfiguration])
            } catch {
                fatalError("Could not create ModelContainer: \(error)")
            }
        }()
        
        let previewHelper = PreviewHelper()
        previewHelper.loadSeedData(skipDataCheck: true)
        
        let seed = SeedData(modelContext: sharedModelContainer.mainContext)
        seed.skipDataCheck = true
        seed.loadSeedData()
        
        let creator = PDFGenerator(categories: seed.seedData, statusManager: statusManager)
        let renderedDocument = creator.renderDocument()
        
        XCTAssertNotNil(renderedDocument)

        #if DEBUG
        let docUrl = renderedDocument?.documentURL?.absoluteString ?? "NO DOCUMENT URL!"
        print("\n-------------docUrl-----------------")
        print(docUrl)
        print("--------------docUrl----------------\n")
        #endif
    }

    /// Regression test for a real dark-mode bug: PDFGenerator's text/header colors used to
    /// come straight from adaptive SwiftUI Colors, so generating a PDF while the device was
    /// in Dark Mode drew near-white text on the PDF's fixed white page. Proves the colors
    /// are now frozen to their light-appearance values by asking them to resolve against a
    /// *dark* trait collection and confirming that has no effect - a still-adaptive color
    /// would return something different (and much lighter) here.
    @MainActor
    func testTextColorsStayLegibleRegardlessOfDeviceAppearance() throws {
        let generator = PDFGenerator(categories: [], statusManager: statusManager)
        let darkAppearance = UITraitCollection(userInterfaceStyle: .dark)

        XCTAssertEqual(generator.textColor, generator.textColor.resolvedColor(with: darkAppearance))
        XCTAssertEqual(generator.headerColor, generator.headerColor.resolvedColor(with: darkAppearance))

        var textWhite: CGFloat = 0
        XCTAssertTrue(generator.textColor.getWhite(&textWhite, alpha: nil))
        XCTAssertLessThan(textWhite, 0.6, "Text color is too light to read on the PDF's white page")
    }

}
