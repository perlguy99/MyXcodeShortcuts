//
//  StatusManager.swift
//  MyXcodeShortcuts
//
//  Created by Brent Michalski on 4/11/24.
//

import SwiftUI

class StatusManager: ObservableObject {
    @Published var status: Status {
        didSet {
            UserDefaults.standard.set(status.rawValue, forKey: Constants.Keys.statusInt.rawValue)
        }
    }
    
    init() {
        self.status = Status(rawValue: UserDefaults.standard.integer(forKey: Constants.Keys.statusInt.rawValue))
    }
}
