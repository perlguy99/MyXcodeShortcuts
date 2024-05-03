//
//  ThemeManager.swift
//  MyXcodeShortcuts
//
//  Created by Brent Michalski on 5/2/24.
//

import SwiftUI

struct ThemeManager {
    static let categoryHeaderTextColor = Color.appTextHeaderRed
    static let appPrimaryTextColor = Color.appPrimaryText
    static let appSecondaryTextColor = Color.appSecondaryText
    static let appPDFHeaderColor = Color.appBaseBlue
    static let filterNoneColor = Color.appBaseBlue
    
    static func filterButtonColor(for status: Status) -> Color {
        switch status {
            case .none:
                return .appNoneBackground
            case .favorite:
                return .appFavoriteBackground
            case .hidden:
                return .appHiddenBackground
        }
    }
    
    static func backgroundColor(for status: Status) -> Color {
        switch status {
            case .none:
                return .appNoneBackground
            case .favorite:
                return .appFavoriteBackground
            case .hidden:
                return .appHiddenBackground
        }
    }
    
    static func foregroundColor(for status: Status) -> Color {
        switch status {
            case .none:
                return .appNoneForeground
            case .favorite:
                return .appFavoriteForeground
            case .hidden:
                return .appHiddenForeground
        }
    }
    
    static func borderColor(for status: Status) -> Color {
        switch status {
            case .none:
                return .appNoneBorder
            case .favorite:
                return .appFavoriteBorder
            case .hidden:
                return .appHiddenBorder
        }
    }
}

