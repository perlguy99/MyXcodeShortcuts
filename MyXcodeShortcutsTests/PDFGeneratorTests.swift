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
        
        let docUrl = renderedDocument?.documentURL?.absoluteString ?? "NO DOCUMENT URL!"
        print("\n-------------docUrl-----------------")
        print(docUrl)
        print("--------------docUrl----------------\n")
    }
    
}
