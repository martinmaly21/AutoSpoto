//
//  CreatePlaylistButton.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-03-04.
//

import SwiftUI

struct CreatePlaylistButton: View {
    let width: CGFloat
    let height: CGFloat
    let action: () -> Void

    var body: some View {
        ZStack {
            Color.spotifyGreen
                .shadow(color: .black.opacity(0.2), radius: 6, x: 4, y: -3)
            
            Button(
                action: action,
                label: {
                    HStack(spacing: 12) {
                        Image("spotify-logo")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.textPrimaryWhite)
                            .frame(width: 30, height: 30)

                        Text(AutoSpotoConstants.Strings.CREATE_PLAYLIST)
                            .font(.josefinSansSemibold(18))
                    }
                    .padding(.horizontal, 30)
                    
                    .foregroundColor(Color.textPrimaryWhite)
                }
            )
            .buttonStyle(.plain)
        }
        .frame(height: height)
        .frame(width: width)
    }
}
