//
//  ChatRow.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-02-09.
//

import SwiftUI

struct ChatRow: View {
    let chatImage: Data?
    let chatDisplayName: String
    let chatSpotifyPlaylistExists: Bool
    let numberOfTracks: Int
    let numberOfUnsyncedTracks: Int
    
    let isSelected: Bool
    let isGroupChat: Bool

    var body: some View {
        VStack(spacing: 2) {
            HStack(alignment: .center, spacing: 5) {
                PersonPictureView(
                    base64ImageData: chatImage,
                    dimension: 40,
                    isSelected: isSelected,
                    isGroupChat: isGroupChat
                )
                .padding(.trailing, 5)

                VStack(alignment: .leading, spacing: 0) {
                    Text(chatDisplayName)
                        .font(.josefinSansRegular(18))
                        .foregroundColor(isSelected ? .textPrimaryWhite : .textPrimary)
                    
                    HStack {
                        Text(String.localizedStringWithFormat(AutoSpotoConstants.Strings.NUMBER_OF_TRACKS, numberOfTracks))
                            .font(.josefinSansLight(16))
                            .foregroundColor(isSelected ? .textPrimaryWhite : .textPrimary)
                        
                        if chatSpotifyPlaylistExists && numberOfUnsyncedTracks > 0 {
                            Text(String.localizedStringWithFormat(AutoSpotoConstants.Strings.NUMBER_OF_UNSYNCED_TRACKS, numberOfUnsyncedTracks))
                                .font(.josefinSansLight(16))
                                .foregroundColor(Color.red)
                        }
                    }
                }

                Spacer()

                if chatSpotifyPlaylistExists {
                    Image("spotify-logo")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.spotifyGreen)
                }
            }
            .multilineTextAlignment(.leading)
            .padding([.leading, .trailing], 16)
            .padding(.bottom, 8)

            Rectangle()
                .frame(height: 0.5)
                .frame(maxWidth: .infinity)
                .background(Color.textPrimary)
                .opacity(isSelected ? 0 : 0.2)
        }
        .padding(.top, 8)
        .frame(maxHeight: 60)
        .contentShape(Rectangle())
        .background(isSelected ? Color.primaryBlue : Color.clear)
    }
}
