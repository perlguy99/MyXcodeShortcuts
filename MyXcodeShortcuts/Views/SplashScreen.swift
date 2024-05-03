//
//  SplashScreen.swift
//  MyXcodeShortcuts
//
//  Created by Brent Michalski on 4/23/24.
//

import SwiftUI

struct SplashScreen: View {
    var body: some View {
        VStack {
            Spacer()
                
            Text("Welcome to")
                .font(.largeTitle)
                .multilineTextAlignment(.center)

            Text("My Shortcuts for Xcode")
                .font(.largeTitle)
                .multilineTextAlignment(.center)

            Spacer()
            Image("AppIconTransparent")
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
            
            Spacer()
            

            
            Spacer()
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
        .background(.appBaseBlue).opacity(0.8)
    }
}

#Preview {
    SplashScreen()
}
