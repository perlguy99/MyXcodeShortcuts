//
//  Constants.swift
//  MyXcodeShortcuts
//
//  Created by Brent Michalski on 4/1/24.
//

import Foundation

enum Constants {
    static let defaultTitle = "My Xcode Faves"
    static let defaultSeparator = " "
    static let defaultShowSymbols = true
    static let defaultShowHidden = true
    static let defaultShowOnlyFavorites = false
    
    enum Keys: String {
        case pdfTitle
        case customSeparator
        case showHidden
        case showSymbols
        case showOnlyFavorites
    }
}
