//
//  StatusManager.swift
//  MyXcodeShortcuts
//
//  Created by Brent Michalski on 4/19/24.
//

import SwiftUI
import Combine

class StatusManager: ObservableObject {
    @Published var currentStatus: Status {
        didSet {
            // Directly write to UserDefaults to avoid recursion and ensure synchronization
            UserDefaults.standard.set(currentStatus.rawValue, forKey: Constants.Keys.statusInt.rawValue)
        }
    }
    
    // Initialize directly without relying on AppStorage wrapping
    init() {
        let statusValue = UserDefaults.standard.integer(forKey: Constants.Keys.statusInt.rawValue)
        
        let status = Status(rawValue: statusValue)
            _currentStatus = Published(initialValue: status)
    }
    
    func toggleStatus() {
        currentStatus.toggle()
    }
}
