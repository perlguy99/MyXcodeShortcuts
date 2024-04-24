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
    
    static let allOld: [KeyData] = KeyboardSymbols.symbols.map { (_, details) in
        KeyData(symbol: details.0, name: details.1)
    }
    
    static let order = ["command", "option", "control", "shift", "tab", "return", "leftarrow", "uparrow", "downarrow", "rightarrow"]
    
    static let all: [KeyData] = {
        let unorderedKeys = KeyboardSymbols.symbols.map { KeyData(symbol: $0.value.0, name: $0.value.1) }
        return unorderedKeys.sorted { order.firstIndex(of: $0.name.lowercased()) ?? Int.max < order.firstIndex(of: $1.name.lowercased()) ?? Int.max  }
    }()
}
