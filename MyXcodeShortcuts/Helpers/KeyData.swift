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
    
    static let order = ["cmd", "opt", "ctrl", "shift", "tab", "return", "leftarrow", "uparrow", "downarrow", "rightarrow"]
}

