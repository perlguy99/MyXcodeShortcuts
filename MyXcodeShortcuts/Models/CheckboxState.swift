//
//  CheckboxState.swift
//  MyXcodeShortcuts
//
//  Created by Brent Michalski on 4/1/24.
//

import SwiftUI
import Combine

enum CheckboxState: Int, Codable {
    case none = 0
    case favorite = 1
    case hidden = 2
}

class SharedCheckboxState: ObservableObject {
    @Published var state: CheckboxState = .none
    
    func toggleState() {
        switch state {
        case .none:
            state = .hidden
        case .hidden:
            state = .favorite
        case .favorite:
            state = .none
        }
    }
}

extension SharedCheckboxState {
    static var mockState: SharedCheckboxState = .init()
}

//extension Category {
//    static let mock: Category = .init(name: "Mock Category")
//}
