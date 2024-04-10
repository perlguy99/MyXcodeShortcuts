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
    @AppStorage(Constants.Keys.pdfTitle.stringValue) var pdfTitle = Constants.defaultTitle
    @AppStorage(Constants.Keys.customSeparator.rawValue) var customSeparator = Constants.defaultSeparator

    override func setUp() {
        super.setUp()
        
        pdfTitle = Constants.defaultTitle
        customSeparator = Constants.defaultSeparator
    }
    
    override func tearDown() {
        super.tearDown()
        
        pdfTitle = Constants.defaultTitle
        customSeparator = Constants.defaultSeparator
    }
    
    func testDefaultTitleWhenNoTitleSet() throws {
        XCTAssertEqual(pdfTitle, Constants.defaultTitle, "\n\nExpected: \(Constants.defaultTitle)\nBut got: \(pdfTitle)\n\n")
        XCTAssertEqual(customSeparator, Constants.defaultSeparator, "\n\nExpected: \(Constants.defaultSeparator)\nBut got: \(customSeparator)\n\n")
    }
    
    func testProperTitleWhenTitleSet() throws {
        let otherTitle = "OtHeR TiTlE"
        let otherSeparator = ""
        pdfTitle = otherTitle
        customSeparator = otherSeparator
        
        XCTAssertEqual(pdfTitle, otherTitle, "\n\nExpected: \(otherTitle)\nBut got: \(pdfTitle)\n\n")
        XCTAssertEqual(customSeparator, otherSeparator, "\n\nExpected: \(otherSeparator)\nBut got: \(customSeparator)\n\n")
        
        // Double-check
        XCTAssertEqual(pdfTitle, otherTitle, "\n\nExpected: \(otherTitle)\nBut got: \(pdfTitle)\n\n")
        XCTAssertEqual(customSeparator, otherSeparator, "\n\nExpected: \(otherSeparator)\nBut got: \(customSeparator)\n\n")
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
        
        // TODO: Need to get the seed data back out of the database!
        let seed = SeedData(modelContext: sharedModelContainer.mainContext)
        seed.skipDataCheck = true
        seed.loadSeedData()
        
        let creator = PDFGenerator(categories: seed.seedData)
        let renderedDocument = creator.renderDocument()
        
        XCTAssertNotNil(renderedDocument)
        
        let docUrl = renderedDocument?.documentURL?.absoluteString ?? "NO DOCUMENT URL!"
        print("\n-------------docUrl-----------------")
        print(docUrl)
        print("--------------docUrl----------------\n")
    }
    
}
