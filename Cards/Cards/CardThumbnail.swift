//
//  CardThumbnail.swift
//  Cards
//
//  Created by Brent Michalski on 5/15/24.
//

import SwiftUI

struct CardThumbnail: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .foregroundColor(.gray)
            .frame(width: 150, height: 250)
    }
}

#Preview {
    CardThumbnail()
}
