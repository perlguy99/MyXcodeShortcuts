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

            Spacer()
            Image("MyAppIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
            
            Spacer()
            
            Text("My Xcode Shortcuts")
                .font(.largeTitle)
                .multilineTextAlignment(.center)

            
            Spacer()
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
        .background(Color("AccentColor"))
    }
}

#Preview {
    SplashScreen()
}
