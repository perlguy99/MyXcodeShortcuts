//
//  RootView.swift
//  MyXcodeShortcuts
//
//  Created by Brent Michalski on 5/6/24.
//

import SwiftUI

struct RootView: View {
    @Binding var isActive: Bool
    
    var body: some View {
        ZStack {
            if isActive {
                ContentView()
            } else {
                SplashScreen()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(.easeOut(duration: 1.0)) {
                    isActive = true
                }
            }
        }
    }
}

#Preview {
    RootView(isActive: .constant(true))
}
