//
//  MyXcodeShortcutsTests.swift
//  MyXcodeShortcutsTests
//
//  Created by Brent Michalski on 4/1/24.
//

import XCTest
@testable import MyXcodeShortcuts

final class MyXcodeShortcutsTests: XCTestCase {
    let expectedStartingCount = 6
    
    let expectedFilterCountNone = 6
    let expectedFilterCountHidden = 4
    let expectedFilterCountFavorite = 1

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testFilterShortcuts() throws {
        let previewHelper = PreviewHelper()
        previewHelper.loadSampleData()
        
        var filterOn: CheckboxState = .none
        let testSharedCheckboxState: CheckboxState = .none
        
        let startingCategory = previewHelper.previewCategory
        
        let startingCount = previewHelper.previewCategory.shortcuts!.count
        XCTAssertEqual(startingCount, expectedStartingCount)
        
        let filteredNone = startingCategory.filteredShortcuts(filterValue: .none)
        let filteredHidden = startingCategory.filteredShortcuts(filterValue: .hidden)
        let filteredFavorite = startingCategory.filteredShortcuts(filterValue: .favorite)
        
        XCTAssertEqual(filteredNone?.count, expectedFilterCountNone)
        XCTAssertEqual(filteredHidden?.count, expectedFilterCountHidden)
        XCTAssertEqual(filteredFavorite?.count, expectedFilterCountFavorite)
    }


}
