//
//  ModifyPlaylistButton.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-06-10.
//

import SwiftUI
import Kingfisher

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
                        if let imageURL = spotifyPlaylist?.imageURL {
                            KFImage(imageURL)
                                .placeholder {
                                    Color.gray
                                        .frame(width: 40, height: 40)
                                        .cornerRadius(8)
                                }
                                .cacheOriginalImage(true)
                                .fade(duration: 0.25)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 40, height: 40)
                                .cornerRadius(8)
                                .aspectRatio(contentMode: .fill)
                        }
                        
                        if let name = spotifyPlaylist?.name {
                            Text(String.localizedStringWithFormat(AutoSpotoConstants.Strings.MODIFY_PLAYLIST_WITH_NAME, name))
                                .font(.josefinSansSemibold(18))
                        } else {
                            Text(AutoSpotoConstants.Strings.MODIFY_PLAYLIST)
                                .font(.josefinSansSemibold(18))
                        }
                    }
                    .padding(.horizontal, 30)
                    .redacted(reason: spotifyPlaylist == nil ? .placeholder : [])
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
