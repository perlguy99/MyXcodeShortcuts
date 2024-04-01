//
//  Item.swift
//  MyXcodeShortcuts
//
//  Created by Brent Michalski on 4/1/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
