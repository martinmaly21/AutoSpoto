//
//  ModifyPlaylistButton.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-06-10.
//

import SwiftUI
import Kingfisher

struct ModifyPlaylistButton: View {
    @Environment(\.openURL) private var openURL
    
    let chat: Chat
    let width: CGFloat
    let height: CGFloat
    
    var spotifyPlaylist: SpotifyPlaylist? {
        return chat.spotifyPlaylist
    }
    
    var body: some View {
        ZStack {
            Color.clear
                .background(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.2), radius: 6, x: 4, y: -3)
                .frame(height: height)
                .frame(width: width)
            
            HStack {
                HStack {
                    VStack {
                        HStack {
                            Text(AutoSpotoConstants.Strings.CONNECTED_TO)
                                .font(.josefinSansBold(16))
                            
                            Spacer()
                        }
                        
                        HStack(spacing: 10) {
                            KFImage(spotifyPlaylist?.imageURL)
                                .placeholder {
                                    Image("spotify-logo")
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundColor(.spotifyGreen)
                                        .frame(width: 70, height: 70)
                                }
                                .cacheOriginalImage(true)
                                .fade(duration: 0.25)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 70, height: 70)
                                .cornerRadius(8)
                                .aspectRatio(contentMode: .fill)
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text(spotifyPlaylist?.name ?? AutoSpotoConstants.Strings.CHAT_NAME_PLACEHOLDER)
                                    .font(.josefinSansRegular(22))
                                    .font(.headline)
                                
                                Button(
                                    action: {
                                        if let url = spotifyPlaylist?.url {
                                            openURL(url)
                                        }
                                    },
                                    label: {
                                        Text(spotifyPlaylist?.url?.absoluteString ?? AutoSpotoConstants.Strings.CHAT_URL_PLACEHOLDER)
                                            .font(.josefinSansRegular(15))
                                            .foregroundColor(.spotifyGreen)
                                            .underline(pattern: .solid)
                                        
                                    }
                                )
                                .buttonStyle(.plain)
                            }
                            
                            Spacer()
                        }
                    }
                    Spacer()
                    
                    VStack(alignment: .center, spacing: 12) {
                        SyncButton(
                            title: AutoSpotoConstants.Strings.SYNC_TRACKS,
                            action: {
                                Task {
                                    //TODO:
                                    //                                await homeViewModel.disconnectPlaylist(for: chat)
                                }
                                
                            }
                        )
                        
                        Button(
                            action: {
                                Task {
                                    //TODO:
                                    //                            await homeViewModel.disconnectPlaylist(for: chat)
                                }
                            },
                            label: {
                                Text(AutoSpotoConstants.Strings.DISCONNECT_CHAT_FROM_PLAYLIST)
                                    .font(.josefinSansRegular(15))
                                    .foregroundColor(.errorRed)
                                    .underline(pattern: .solid)
                            }
                        )
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.horizontal, 16.5)
            .frame(height: height)
            .frame(width: width)
            .redacted(reason: spotifyPlaylist == nil ? .placeholder : [])
        }
    }
}
