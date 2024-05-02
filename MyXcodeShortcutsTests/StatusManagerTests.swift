//
//  StatusManagerTests.swift
//  MyXcodeShortcutsTests
//
//  Created by Brent Michalski on 4/20/24.
//

import XCTest
@testable import MyXcodeShortcuts

class StatusManagerTests: XCTestCase {
    
//    var statusManager: (any StatusManaging)?
    var statusManager: StatusManager!
    var mockUserDefaults: MockUserDefaults!
    
    let defaultPDFTitle = "Default PDF Title"
    let customTitle = "Custom Title"
    let defaultSeparator = "-"
    let customSeparator = " "
    let defaultShowSymbols = true
    let customShowSymbols = false
    let defaultCurrentStatus = Status.none
    let customCurrentStatus = Status.favorite
    
    
    override func setUp() {
        super.setUp()
        
        mockUserDefaults = MockUserDefaults(initialValues: [
            Constants.Keys.statusInt: defaultCurrentStatus.rawValue,
            Constants.Keys.pdfTitle: defaultPDFTitle,
            Constants.Keys.separator: defaultSeparator,
            Constants.Keys.showSymbols: defaultShowSymbols
        ])

        statusManager = StatusManager(userDefaults: mockUserDefaults)
        statusManager?.userDefaults = mockUserDefaults
    }
    
        override func tearDown() {
            statusManager = nil
            super.tearDown()
        }

    func testInitialize_StatusManager_Defaults() {
        print("\n------------------------------")
        print(mockUserDefaults.integer(forKey: Constants.Keys.statusInt))
        print(mockUserDefaults.string(forKey: Constants.Keys.pdfTitle))
        print("---")
        print(statusManager?.userDefaults.string(forKey: Constants.Keys.pdfTitle))
        print(statusManager?.currentStatus)
        print(statusManager?.pdfTitle)
//        print(statusManager?.separator)
//        print(statusManager?.showSymbols)
        print("------------------------------\n")
        
        print("\n-------------statusManager?.currentStatus-----------------")
        print(statusManager?.currentStatus)
        print(mockUserDefaults.integer(forKey: Constants.Keys.statusInt))
        
        print("--------------statusManager?.currentStatus----------------\n")
        
        XCTAssertEqual(statusManager?.currentStatus, defaultCurrentStatus)
        XCTAssertEqual(statusManager?.pdfTitle, defaultPDFTitle)
        XCTAssertEqual(statusManager?.separator, defaultSeparator)
        XCTAssertEqual(statusManager?.showSymbols, defaultShowSymbols)
    }

    
    func testInitializeMockUserDefaults() {
        XCTAssertEqual(statusManager?.currentStatus, defaultCurrentStatus)
        XCTAssertEqual(statusManager?.pdfTitle, defaultPDFTitle)
        XCTAssertEqual(statusManager?.separator, defaultSeparator)
        XCTAssertEqual(statusManager?.showSymbols, defaultShowSymbols)
        
        customizeMockUserDefaults()
        
        XCTAssertEqual(statusManager?.currentStatus, customCurrentStatus)
        XCTAssertEqual(statusManager?.pdfTitle, customTitle)
        XCTAssertEqual(statusManager?.separator, customSeparator)
        XCTAssertEqual(statusManager?.showSymbols, customShowSymbols)
    }

    
    func customizeMockUserDefaults() {
        statusManager?.currentStatus = customCurrentStatus
        statusManager?.pdfTitle = customTitle
        statusManager?.separator = customSeparator
        statusManager?.showSymbols = customShowSymbols
    }
    
    func testStatusManagerWithMockUserDefaults() {
        // Initial checks
        XCTAssertEqual(statusManager?.currentStatus, defaultCurrentStatus)
        XCTAssertEqual(statusManager?.pdfTitle, defaultPDFTitle)
        
        // Simulate changing values
        statusManager?.currentStatus = .favorite
        statusManager?.pdfTitle = customTitle
        
        // Check values changed in mock storage
        XCTAssertEqual(mockUserDefaults.integer(forKey: Constants.Keys.statusInt), Status.favorite.rawValue)
        XCTAssertEqual(mockUserDefaults.string(forKey: Constants.Keys.pdfTitle), customTitle)
        
        // Functionality tests
        statusManager?.toggleStatus()
        XCTAssertEqual(statusManager?.currentStatus, .hidden, "Status should toggle to hidden")
    }
    
    func testStatusToggle() {
        let mockManager = MockStatusManager()
        let initialStatus = mockManager.currentStatus
        mockManager.toggleStatus()
        XCTAssertNotEqual(mockManager.currentStatus, initialStatus, "Status should toggle")
    }

    
}
