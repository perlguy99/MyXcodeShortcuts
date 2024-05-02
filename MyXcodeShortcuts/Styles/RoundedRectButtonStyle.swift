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
                    .stroke(ThemeManager.borderColor(for: checkboxState), lineWidth: 3)
            )
            .foregroundColor(ThemeManager.foregroundColor(for: checkboxState))
            .background(ThemeManager.backgroundColor(for: checkboxState))
            .scaleEffect(configuration.isPressed ? 0.95 : 1) // Optional: Change scale when pressed
    }
}
