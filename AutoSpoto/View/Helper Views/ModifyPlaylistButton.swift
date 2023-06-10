//
//  ModifyPlaylistButton.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-06-10.
//

import SwiftUI

struct ModifyPlaylistButton: View {
    let spotifyPlaylist: SpotifyPlaylist?
    let width: CGFloat
    let height: CGFloat
    let action: () -> Void
    
    var body: some View {
        Button(
            action: action,
            label: {
                ZStack {
                    Color.spotifyGreen
                        .shadow(color: .black.opacity(0.2), radius: 6, x: 4, y: -3)
                    
                    HStack(spacing: 12) {
                        Image("spotify-logo")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.textPrimaryWhite)
                            .frame(width: 30, height: 30)
                        
                        Text(spotifyPlaylist?.id ?? AutoSpotoConstants.Strings.MODIFY_PLAYLIST)
                            .font(.josefinSansSemibold(18))
                    }
                    .padding(.horizontal, 30)
                    
                    .foregroundColor(Color.textPrimaryWhite)
                }
                .frame(height: height)
                .frame(width: width)
            }
        )
        .buttonStyle(.borderless)
        .contentShape(Rectangle())
    }
}
