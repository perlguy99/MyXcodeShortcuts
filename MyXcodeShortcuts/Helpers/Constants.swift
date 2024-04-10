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
    static let defaultStatusInt = 0
    
    enum Keys: String, StringRepresentable {
        case pdfTitle
        case separator
        case showHidden
        case showSymbols
        case statusInt
    }
}


