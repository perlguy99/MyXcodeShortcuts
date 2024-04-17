//
//  KeyData.swift
//  MyXcodeShortcuts
//
//  Created by Brent Michalski on 4/17/24.
//

import Foundation

struct KeyData: Hashable {
    let symbol: String
    let name: String
    
    static let all = [
        KeyData(symbol: Constants.cmdSymbol, name: Constants.cmdString),
        KeyData(symbol: Constants.ctrlSymbol, name: Constants.ctrlString),
        KeyData(symbol: Constants.optSymbol, name: Constants.optString),
        KeyData(symbol: Constants.shiftSymbol, name: Constants.shiftString),
        KeyData(symbol: Constants.returnSymbol, name: Constants.returnString)
    ]
}

