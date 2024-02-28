//
//  ContactUsButton.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-08-24.
//

import SwiftUI

struct ContactUsButton: View {
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 4) {
            Button(
                action: action,
                label: {
                    Text(AutoSpotoConstants.Strings.CONTACT_AUTOSPOTO)
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
}
