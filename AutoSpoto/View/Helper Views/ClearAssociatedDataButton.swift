//
//  ClearAssociatedDataButton.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-08-24.
//

import SwiftUI

struct ClearAssociatedDataButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(
            action: action,
            label: {
                Text(AutoSpotoConstants.Strings.CLEAR_ASSOCIATED_DATA)
                    .font(.josefinSansBold(14))
                    .padding(6)
                    .padding(.horizontal, 8)
                    .background(Color.spotifyGreen)
                    .foregroundColor(Color.white)
                    .clipShape(Capsule())
            }
        )
        .buttonStyle(.plain)
    }
}
