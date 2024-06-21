//
//  StatusManagerTestsAI.swift
//  MyXcodeShortcutsTests
//
//  Created by Brent Michalski on 5/1/24.
//

import XCTest
@testable import MyXcodeShortcuts

class StatusManagerTestsAI: XCTestCase {
    
    var statusManager: StatusManager!
    var userDefaults: UserDefaults!
    
    override func setUp() {
        super.setUp()
        // Initialize a mock UserDefaults instance
        userDefaults = UserDefaults(suiteName: #file)
        userDefaults.removePersistentDomain(forName: #file)
        
        // Pre-set some defaults to mimic existing settings
        userDefaults.set(Status.favorite.rawValue, forKey: Constants.Keys.statusInt)
        userDefaults.set("Sample PDF", forKey: Constants.Keys.pdfTitle)
        userDefaults.set("-", forKey: Constants.Keys.separator)
        userDefaults.set(true, forKey: Constants.Keys.showSymbols)
        
        statusManager = StatusManager()
    }
    
    override func tearDown() {
        userDefaults.removePersistentDomain(forName: #file)
        super.tearDown()
    }
    
    func testInitialValues() {
        // Check initial values loaded correctly from UserDefaults
        XCTAssertEqual(statusManager.currentStatus, .favorite)
        XCTAssertEqual(statusManager.pdfTitle, "Sample PDF")
        XCTAssertEqual(statusManager.separator, "-")
        XCTAssertTrue(statusManager.showSymbols)
    }
    
    func testSetCurrentStatus() {
        // Change status to hidden and check UserDefaults
        statusManager.currentStatus = .hidden
        XCTAssertEqual(userDefaults.integer(forKey: Constants.Keys.statusInt), Status.hidden.rawValue)
    }
    
    func testSetPdfTitle() {
        let newTitle = "Updated PDF Title"
        statusManager.pdfTitle = newTitle
        XCTAssertEqual(userDefaults.string(forKey: Constants.Keys.pdfTitle), newTitle)
    }
    
    func testSetSeparator() {
        let newSeparator = "|"
        statusManager.separator = newSeparator
        XCTAssertEqual(userDefaults.string(forKey: Constants.Keys.separator), newSeparator)
    }
    
    func testToggleStatus() {
        // Assuming initial status is favorite, toggling should make it hidden
        statusManager.toggleStatus()
        XCTAssertEqual(statusManager.currentStatus, .hidden)
        XCTAssertEqual(userDefaults.integer(forKey: Constants.Keys.statusInt), Status.hidden.rawValue)
        
        // Further toggling should wrap around to none
        statusManager.toggleStatus()
        XCTAssertEqual(statusManager.currentStatus, .none)
        XCTAssertEqual(userDefaults.integer(forKey: Constants.Keys.statusInt), Status.none.rawValue)
    }
    
    func testDefaultValuesWhenMissing() {
        // Remove all keys to simulate missing values
        userDefaults.removeObject(forKey: Constants.Keys.statusInt)
        userDefaults.removeObject(forKey: Constants.Keys.pdfTitle)
        userDefaults.removeObject(forKey: Constants.Keys.separator)
        userDefaults.removeObject(forKey: Constants.Keys.showSymbols)
        
        // Reinitialize StatusManager to load potentially missing defaults
        statusManager = StatusManager()
        
        // Verify defaults are handled correctly
        XCTAssertEqual(statusManager.currentStatus, .none) // Default as per enum initializer
        XCTAssertEqual(statusManager.pdfTitle, Constants.defaultTitle)
        XCTAssertEqual(statusManager.separator, Constants.defaultSeparator)
        XCTAssertTrue(statusManager.showSymbols) // Default as true
    }
}
