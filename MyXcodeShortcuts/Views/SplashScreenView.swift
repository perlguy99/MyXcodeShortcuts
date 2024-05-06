//
//  SplashScreenView.swift
//  MyXcodeShortcuts
//
//  Created by Brent Michalski on 5/6/24.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    
    var body: some View {
        if isActive {
            EmptyView()
//            ContentView() // Navigate to the main content view of your app
        } else {
            ZStack {
                Color.black.opacity(0.8).edgesIgnoringSafeArea(.all) // Dark background for contrast
                VStack {
                    Image("AppIconTransparent")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                    
                    Text("My Shortcuts for Xcode") // Your app's name
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer().frame(height: 20) // Adds space between name and indicator
                    
                    ProgressView() // iOS native loading indicator
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { // Simulate loading time
                    self.isActive = true
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
