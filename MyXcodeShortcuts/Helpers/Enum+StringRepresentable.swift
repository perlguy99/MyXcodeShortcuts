//
//  Enum+StringRepresentable.swift
//  MyXcodeShortcuts
//
//  Created by Brent Michalski on 4/7/24.
//

import Foundation

protocol StringRepresentable {
    var stringValue: String { get }
}

extension StringRepresentable where Self: RawRepresentable, Self.RawValue == String {
    var stringValue: String {
        return self.rawValue
    }
}
