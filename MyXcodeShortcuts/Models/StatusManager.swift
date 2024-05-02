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
    internal var userDefaults: UserDefaults
    
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
        _pdfTitle      = Published(initialValue: userDefaults.string(forKey: Constants.Keys.pdfTitle) ?? Constants.defaultTitle)
        _separator     = Published(initialValue: userDefaults.string(forKey: Constants.Keys.separator) ?? Constants.defaultSeparator)
        
        // Check if the showSymbols key exists and set it to true if it does not
        let showSymbolsValue = userDefaults.object(forKey: Constants.Keys.showSymbols) as? Bool
        _showSymbols   = Published(initialValue: showSymbolsValue ?? true)
    }

    func toggleStatus() {
        currentStatus.toggle()
    }
}
