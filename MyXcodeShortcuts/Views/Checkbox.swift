//
//  Checkbox.swift
//  MyXcodeShortcuts
//
//  Created by Brent Michalski on 4/1/24.
//

import SwiftUI

struct Checkbox: View {
    @Binding var state: CheckboxState
    
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
            state = CheckboxState(rawValue: 1)!
        } else if state.rawValue == 1 {
            state = CheckboxState(rawValue: 2)!
        } else if state.rawValue == 2 {
            state = CheckboxState(rawValue: 0)!
        }
    }
}

struct Checkbox_Previews: PreviewProvider {
//    let previewHelper = PreviewHelper()
    
        static var previews: some View {
            OtherView()
        }

    private struct OtherView: View {
        @State var favorite: CheckboxState = .favorite
        @State var hidden: CheckboxState = .hidden
        @State var none: CheckboxState = .none
        
        var body: some View {
            VStack {
                Checkbox(state: $none)
                Checkbox(state: $favorite)
                Checkbox(state: $hidden)
            }
        }
    }
}


//#Preview {
//    Checkbox()
//}
