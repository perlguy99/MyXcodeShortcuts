//
//  StatusManagerTests.swift
//  MyXcodeShortcutsTests
//
//  Created by Brent Michalski on 4/20/24.
//

import XCTest
@testable import MyXcodeShortcuts

final class StatusManagerTests: XCTestCase {

    var statusManager: StatusManager!
    var mockUserDefaults: MockUserDefaults!
    
    override func setUp() {
        super.setUp()
        mockUserDefaults = MockUserDefaults()
        statusManager = StatusManager(userDefaults: mockUserDefaults)
    }
    
    override func tearDown() {
        statusManager = nil
        mockUserDefaults = nil
        super.tearDown()
    }
    
    func testInitialization() {
        // Setup initial UserDefaults values
        mockUserDefaults.set(1, forKey: Constants.Keys.statusInt)
        mockUserDefaults.set("Custom Title", forKey: Constants.Keys.pdfTitle)
        mockUserDefaults.set(" ", forKey: Constants.Keys.separator)
        mockUserDefaults.set(true, forKey: Constants.Keys.showSymbols)
    }
    
    func testPropertyChanges() {
        // Test changing each property updates UserDefaults
        statusManager.currentStatus = .favorite
        XCTAssertEqual(mockUserDefaults.integer(forKey: Constants.Keys.statusInt), 1)
        
        statusManager.pdfTitle = "Updated Title"
        XCTAssertEqual(mockUserDefaults.string(forKey: Constants.Keys.pdfTitle), "Updated Title")
        
        statusManager.separator = ","
        XCTAssertEqual(mockUserDefaults.string(forKey: Constants.Keys.separator), ",")
        
        statusManager.showSymbols = false
        XCTAssertEqual(mockUserDefaults.bool(forKey: Constants.Keys.showSymbols), false)
    }
    
    func testToggleStatus() {
        // Default is '.none' with a rawValue = 0
        statusManager.currentStatus = .none
        statusManager.toggleStatus()
        
        XCTAssertEqual(statusManager.currentStatus.rawValue, 1)
        
        statusManager.toggleStatus()
        XCTAssertEqual(statusManager.currentStatus.rawValue, 2)

        statusManager.toggleStatus()
        XCTAssertEqual(statusManager.currentStatus.rawValue, 0)

    }
    
    
}
