//
//  Checkbox.swift
//  MyXcodeShortcuts
//
//  Created by Brent Michalski on 4/1/24.
//

import SwiftUI

struct Checkbox: View {
    @Binding var state: Status
    
    var body: some View {
        return Button(action: buttonTap) {
            switch state {
            case .none:
                Image(uiImage: UIImage())
            case .favorite:
                Image(systemName: "star.fill")
            case .hidden:
                Image(systemName: "eye.slash")
            }
        }
        .buttonStyle(RoundedRectButtonStyle(checkboxState: state))
    }
        
    // Tap only toggles favorite on/off. Hiding (and un-hiding) happens via the
    // swipe action instead, so a stray tap can never make a row silently vanish.
    func buttonTap() {
        state = state == .favorite ? .none : .favorite
    }
}

struct Checkbox_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OtherView()
            OtherViewDark()
        }
    }
    
    private struct OtherView: View {
        @State var favorite: Status = .favorite
        @State var hidden: Status = .hidden
        @State var none: Status = .none
        
        var body: some View {
            VStack {
                Checkbox(state: $none)
                Checkbox(state: $favorite)
                Checkbox(state: $hidden)
            }
        }
    }
    
    private struct OtherViewDark: View {
        @State var favorite: Status = .favorite
        @State var hidden: Status = .hidden
        @State var none: Status = .none
        
        var body: some View {
            VStack {
                Checkbox(state: $none)
                Checkbox(state: $favorite)
                Checkbox(state: $hidden)
            }
            .preferredColorScheme(.dark)
        }
    }

}

