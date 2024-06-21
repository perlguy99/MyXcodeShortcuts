//
//  StatusManager.swift
//  MyXcodeShortcuts
//
//  Created by Brent Michalski on 4/19/24.
//

import SwiftUI

class StatusManager: ObservableObject {
    @AppStorage(Constants.Keys.statusInt) private var statusInt: Int = Status.none.rawValue
    @AppStorage(Constants.Keys.pdfTitle) var pdfTitle: String = Constants.defaultTitle
    @AppStorage(Constants.Keys.separator) var separator: String = Constants.defaultSeparator
    @AppStorage(Constants.Keys.showSymbols) var showSymbols: Bool = true
    
    var currentStatus: Status {
        get {
            Status(rawValue: statusInt)
        }
        set {
            statusInt = newValue.rawValue
        }
    }

    func toggleStatus() {
        currentStatus.toggle()
    }
}
