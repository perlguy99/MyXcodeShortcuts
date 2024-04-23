//
//  StatusManager.swift
//  MyXcodeShortcuts
//
//  Created by Brent Michalski on 4/19/24.
//

import SwiftUI
import Combine

class StatusManager: ObservableObject {
    // May be injected for testing and previews
    private var userDefaults: UserDefaults
    
    @Published var currentStatus: Status {
        didSet {
            // Directly write to UserDefaults to avoid recursion and ensure synchronization
            userDefaults.set(currentStatus.rawValue, forKey: Constants.Keys.statusInt)
        }
    }

    @Published var pdfTitle: String {
        didSet {
            userDefaults.set(pdfTitle, forKey: Constants.Keys.pdfTitle)
        }
    }
    
    @Published var separator: String {
        didSet {
            userDefaults.set(separator, forKey: Constants.Keys.separator)
        }
    }
    
    @Published var showSymbols: Bool {
        didSet {
            userDefaults.set(showSymbols, forKey: Constants.Keys.showSymbols)
        }
    }
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        
        _currentStatus = Published(initialValue: Status(rawValue: userDefaults.integer(forKey: Constants.Keys.statusInt)))
        _pdfTitle = Published(initialValue: userDefaults.string(forKey: Constants.Keys.pdfTitle) ?? Constants.defaultTitle)
        _separator = Published(initialValue: userDefaults.string(forKey: Constants.Keys.separator) ?? Constants.defaultSeparator)
        _showSymbols = Published(initialValue: userDefaults.bool(forKey: Constants.Keys.showSymbols))
    }

    func toggleStatus() {
        currentStatus.toggle()
    }
}
