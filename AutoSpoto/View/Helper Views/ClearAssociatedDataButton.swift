//
//  ClearAssociatedDataButton.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-08-24.
//

import SwiftUI

struct ClearAssociatedDataButton: View {
    let isEnabled: Bool
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 4) {
            Button(
                action: action,
                label: {
                    Text(AutoSpotoConstants.Strings.CLEAR_ASSOCIATED_DATA)
                        .font(.josefinSansBold(14))
                        .padding(6)
                        .padding(.horizontal, 8)
                        .background(isEnabled ? Color.spotifyGreen : Color.gray)
                        .foregroundColor(Color.white)
                        .clipShape(Capsule())
                }
            )
            .buttonStyle(.plain)
            .disabled(!isEnabled)
            
            if !isEnabled {
                Text(AutoSpotoConstants.Strings.NO_ASSOCIATED_DATA)
                    .font(.josefinSansLight(14))
            }
        }
    }
}
