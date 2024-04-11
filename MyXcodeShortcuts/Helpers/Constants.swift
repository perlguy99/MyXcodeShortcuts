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
    
    static let cmdSymbol = "\u{2318}"
    static let ctrlSymbol = "\u{2303}"
    static let shiftSymbol = "\u{21E7}"
    static let optSymbol = "\u{2325}"
    static let returnSymbol = "\u{23CE}"
    
    static let cmdString = "cmd"
    static let ctrlString = "ctrl"
    static let shiftString = "shift"
    static let optString = "opt"
    static let returnString = "return"
    
    enum Keys: String, StringRepresentable {
        case pdfTitle
        case separator
        case showHidden
        case showSymbols
        case statusInt
    }
}


