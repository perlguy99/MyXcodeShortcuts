//
//  KeyboardToolbarTests.swift
//  MyXcodeShortcutsTests
//
//  Created by Brent Michalski on 4/19/24.
//

import XCTest
//import SwiftUI
//import SwiftData

@testable import MyXcodeShortcuts

final class KeyboardToolbarTests: XCTestCase {

    func testKeyDataOrder() {
        // Expected order
        let expectedOrder = ["command", "option", "control", "shift", "tab", "return", "leftarrow", "uparrow", "downarrow", "rightarrow"]
        
        // Fetch the names from the KeyData array
        let actualOrder = KeyData.all.map { $0.name.lowercased() }
        
        // Assert that actual order matches the expected order
        XCTAssertEqual(actualOrder, expectedOrder, "The keys in KeyData.all are not in the expected order.")
    }


}
