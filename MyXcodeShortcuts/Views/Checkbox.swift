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
        
    func buttonTap() {
        if state.rawValue == 0 {
            state = Status(rawValue: 1)
        } else if state.rawValue == 1 {
            state = Status(rawValue: 2)
        } else if state.rawValue == 2 {
            state = Status(rawValue: 0)
        }
    }
}

struct Checkbox_Previews: PreviewProvider {
    static var previews: some View {
        OtherView()
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
}
