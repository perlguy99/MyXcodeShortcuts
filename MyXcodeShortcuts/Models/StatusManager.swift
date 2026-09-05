//
//  StatusManager.swift
//  MyXcodeShortcuts
//
//  Created by Brent Michalski on 4/19/24.
//

import Foundation
import Observation

/// Backed by an injected `UserDefaults` store (defaulting to `.standard`) rather than
/// `@AppStorage`, so it can be unit-tested against an isolated store instead of always
/// touching real shared app settings.
@Observable
final class StatusManager {
    @ObservationIgnored private let userDefaults: UserDefaults

    var currentStatus: Status {
        didSet { userDefaults.set(currentStatus.rawValue, forKey: Constants.Keys.statusInt) }
    }
    var pdfTitle: String {
        didSet { userDefaults.set(pdfTitle, forKey: Constants.Keys.pdfTitle) }
    }
    var separator: String {
        didSet { userDefaults.set(separator, forKey: Constants.Keys.separator) }
    }
    var showSymbols: Bool {
        didSet { userDefaults.set(showSymbols, forKey: Constants.Keys.showSymbols) }
    }

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        currentStatus = Status(rawValue: userDefaults.object(forKey: Constants.Keys.statusInt) as? Int ?? Constants.defaultStatusInt)
        pdfTitle = userDefaults.string(forKey: Constants.Keys.pdfTitle) ?? Constants.defaultTitle
        separator = userDefaults.string(forKey: Constants.Keys.separator) ?? Constants.defaultSeparator
        showSymbols = userDefaults.object(forKey: Constants.Keys.showSymbols) as? Bool ?? Constants.defaultShowSymbols
    }

    func toggleStatus() {
        currentStatus.toggle()
    }
}
