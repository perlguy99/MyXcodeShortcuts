//
//  Categories.swift
//  MyXcodeShortcuts
//
//  Created by Brent Michalski on 4/3/24.
//

import Foundation

// Not needed, only used in importing JSON right now
struct Categories: Codable {
    let categories: [Category]
}

// TODO: This is a hack for importing the JSON at the moment
//  Caused by the @Model macro
struct CategoriesX: Codable {
    let categories: [CategoryX]
}
