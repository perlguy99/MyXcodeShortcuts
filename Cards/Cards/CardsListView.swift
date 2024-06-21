//
//  CardsListView.swift
//  Cards
//
//  Created by Brent Michalski on 5/15/24.
//

import SwiftUI

struct CardsListView: View {
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                ForEach(0..<10) { _ in
                    CardThumbnail()
                }
            }
        }
    }
}

#Preview {
    CardsListView()
}

