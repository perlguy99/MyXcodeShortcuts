//
//  MotionAnimationModifier.swift
//  MyXcodeShortcuts
//
//  Created by Brent Michalski on 5/6/24.
//

import SwiftUI

struct MotionAnimationModifier<V: Equatable>: ViewModifier {
    @Environment(\.accessibilityReduceMotion) var accessibilityReduceMotion

    let animation: Animation?
    let value: V

    func body(content: Content) -> some View {
        if accessibilityReduceMotion {
            content
        } else {
            content.animation(animation, value: value)
        }
    }
}

extension View {
    func motionAnimation<V: Equatable>(_ animation: Animation?, value: V) -> some View {
        self.modifier(MotionAnimationModifier(animation: animation, value: value))
    }
}

