//
//  MockStatusManager.swift
//  MyXcodeShortcutsTests
//
//  Created by Brent Michalski on 4/25/24.
//

//import SwiftUI
//@testable import MyXcodeShortcuts

// Mock implementation of StatusManager for testing
//class MockStatusManager: StatusManaging {
//    var userDefaults: UserDefaults
//    
//    @Published var currentStatus: Status
//    @Published var pdfTitle: String
//    @Published var separator: String
//    @Published var showSymbols: Bool
//    
//    init(currentStatus: Status = Status(rawValue: 0), // Set a default initial status if needed
//         pdfTitle: String = "Default PDF Title",
//         separator: String = "-",
//         showSymbols: Bool = true,
//         userDefaults: UserDefaults = UserDefaults.standard
//    ) {
//        self.currentStatus = currentStatus
//        self.pdfTitle = pdfTitle
//        self.separator = separator
//        self.showSymbols = showSymbols
//        self.userDefaults = userDefaults
//    }
//    
//    func toggleStatus() {
//        // Simulate the toggle functionality. You might need to implement the logic based on your Status enum
//        // For example, assuming Status is toggle-able with a binary switch
//        currentStatus = Status(rawValue: (currentStatus.rawValue == 0 ? 1 : 0))
//    }
//}

//class MockStatusManager: StatusManaging {
//    @Published var currentStatus: Status
//    @Published var pdfTitle: String {
//        didSet {
//            print("\n--------------pdfTitle----------------")
//            print("PDF Title Set To: \(pdfTitle)")
//            print("----------------pdfTitle--------------\n")
//        }
//    }
//    @Published var separator: String
//    @Published var showSymbols: Bool
//    
//    internal var userDefaults: UserDefaults
//    
//    init(currentStatus: Status = Status(rawValue: 0),
//         pdfTitle: String = "Default PDF Title",
//         separator: String = "-",
//         showSymbols: Bool = true,
//         userDefaults: UserDefaults = UserDefaults(suiteName: "TestUserDefaults")!) {
//        self.currentStatus = currentStatus
//        self.pdfTitle = pdfTitle
//        self.separator = separator
//        self.showSymbols = showSymbols
//        self.userDefaults = userDefaults
//        
//        // Load initial values from UserDefaults or set to default
//        self.currentStatus = Status(rawValue: userDefaults.integer(forKey: Constants.Keys.statusInt))
//        self.pdfTitle = userDefaults.string(forKey: Constants.Keys.pdfTitle) ?? pdfTitle
//        self.separator = userDefaults.string(forKey: Constants.Keys.separator) ?? separator
//        let storedShowSymbols = userDefaults.object(forKey: Constants.Keys.showSymbols) as? Bool
//        self.showSymbols = storedShowSymbols ?? showSymbols
//        
//        print("\n------------------------------")
//        print(self.currentStatus.stringValue)
//        print(self.pdfTitle)
//        print(self.separator)
//        print(self.showSymbols.description)
//        print("------------------------------\n")
//    }
//    
//    func toggleStatus() {
//        // Implement the logic to toggle the status
//        // Example assuming Status has two states
////        currentStatus = currentStatus == .none ? .inactive : .active
//        currentStatus.toggle()
//        userDefaults.set(currentStatus.rawValue, forKey: Constants.Keys.statusInt)
//    }
//    
//    // Ensure to clean up UserDefaults during tests
//    deinit {
//        userDefaults.removePersistentDomain(forName: "TestUserDefaults")
//    }
//}
//
