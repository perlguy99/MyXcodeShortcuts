//
//  RoundedRectButtonStyle.swift
//  MyXcodeFaves
//
//  Created by Brent Michalski on 3/13/24.
//

import SwiftUI

struct RoundedRectButtonStyle: ButtonStyle {
    var checkboxState: Status = .none
    
    func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .frame(width: 35, height: 35) // Adjust size as needed
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(getBorderColor(), lineWidth: 3)
                )
                .foregroundColor(getForegroundColor())
                .background(getBackgroundColor())
                .scaleEffect(configuration.isPressed ? 0.95 : 1) // Optional: Change scale when pressed
            
    }
    
    func getForegroundColor() -> Color {
        switch checkboxState {
        case .none:
            return .nonePrimary
        case .favorite:
            return .favPrimary
        case .hidden:
            return .hiddenPrimary
        }
    }
    
    func getBorderColor() -> Color {
        switch checkboxState {
        case .none:
            return .noneBorder
        case .favorite:
            return .favoriteBorder
        case .hidden:
            return .hiddenBorder
        }
    }
    
    func getBackgroundColor() -> Color {
        switch checkboxState {
        case .none:
            return .noneBackground
        case .favorite:
            return .favoriteBackground
        case .hidden:
            return .hiddenBackground
        }
    }
}
