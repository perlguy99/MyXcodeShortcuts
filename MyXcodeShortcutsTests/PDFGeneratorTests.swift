//
//  PDFGeneratorTests.swift
//  MyXcodeShortcutsTests
//
//  Created by Brent Michalski on 4/7/24.
//

import XCTest

@testable import MyXcodeShortcuts

final class PDFGeneratorTests: XCTestCase {
    
    var userDefaults: UserDefaults!
    
    override func setUp() {
        super.setUp()
        
        userDefaults = UserDefaults()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    //    @MainActor
    //    func testDefaultTitleWhenNoTitleSet() throws {
    //        do {
    //            var previewHelper = try PreviewHelper()
    ////            previewHelper.loadSeedData()
    //
    //            let vm = SettingsViewModel.shared
    //            // We need to make sure that we start fresh
    //            vm.clearSettings()
    //
    //            let vm2 = SettingsViewModel.shared
    //            vm2.loadSettings()
    //
    //            XCTAssertEqual(vm2.pdfTitle, Constants.defaultTitle, "\n\nExpected: \(Constants.defaultTitle)\nBut got: \(vm2.pdfTitle)\n\n")
    //            XCTAssertEqual(vm2.customSeparator, Constants.defaultSeparator, "\n\nExpected: \(Constants.defaultSeparator)\nBut got: \(vm2.customSeparator)\n\n")
    //
    //
    //        } catch {
    //            print(error.localizedDescription)
    //        }
    //    }
    //
    //    @MainActor
    //    func testProperTitleWhenTitleSet() throws {
    //        let otherTitle = "OtHeR TiTlE"
    //        let otherSeparator = ""
    //
    //        do {
    //            var previewHelper = try PreviewHelper()
    ////            previewHelper.loadSeedData()
    //
    //            let vm = SettingsViewModel.shared
    //            vm.pdfTitle = otherTitle
    //            vm.customSeparator = otherSeparator
    //
    //            let vm2 = SettingsViewModel.shared
    //            vm2.loadSettings()
    //
    //            XCTAssertEqual(vm2.pdfTitle, otherTitle, "\n\nExpected: \(otherTitle)\nBut got: \(vm2.pdfTitle)\n\n")
    //            XCTAssertEqual(vm2.customSeparator, otherSeparator, "\n\nExpected: \(otherSeparator)\nBut got: \(vm2.customSeparator)\n\n")
    //
    //            // Double-check
    //            vm2.loadSettings()
    //            XCTAssertEqual(vm2.pdfTitle, otherTitle, "\n\nExpected: \(otherTitle)\nBut got: \(vm2.pdfTitle)\n\n")
    //            XCTAssertEqual(vm2.customSeparator, otherSeparator, "\n\nExpected: \(otherSeparator)\nBut got: \(vm2.customSeparator)\n\n")
    //
    //        } catch {
    //            print(error.localizedDescription)
    //        }
    //    }
    //
    //    @MainActor
    //    func testRenderDocument() throws {
    //        let testDefaultSeparator = "="
    //        let testDefaultTitle = "Default PDF Title XYZ"
    //
    //        do {
    //            var previewHelper = try PreviewHelper()
    ////            previewHelper.loadSeedData()
    //
    //            let vm = SettingsViewModel.shared
    //            vm.customSeparator = testDefaultSeparator
    //            vm.pdfTitle = testDefaultTitle
    //
    //            let vm2 = SettingsViewModel.shared
    //            vm2.loadSettings()
    //
    //            let creator = PDFGenerator(categories: previewHelper.seedData)
    //            let renderedDocument = creator.renderDocument()
    //
    //            XCTAssertNotNil(renderedDocument)
    //
    //            let docUrl = renderedDocument?.documentURL?.absoluteString ?? "NO DOCUMENT URL!"
    //            print("\n-------------docUrl-----------------")
    //            print(docUrl)
    //            print("--------------docUrl----------------\n")
    //
    //        } catch {
    //            print(error.localizedDescription)
    //        }
    //
    //    }
    //
    //
    //}
}
