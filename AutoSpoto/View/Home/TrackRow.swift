//
//  TrackRow.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-02-10.
//

import SwiftUI
import Kingfisher


struct TrackRow: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    let chat: Chat
    let track: Track

    private var errorMessage: String? {
        guard chat.errorFetchingTracks else {
            return nil
        }

        return String.localizedStringWithFormat(
            AutoSpotoConstants.Strings.ERROR_FETCHING_TRACK_METADATA,
            track.url.absoluteString
        )
    }

    var body: some View {
        let trackMetadataIsLoading = chat.hasNotFetchedAndIsFetchingTracks

        VStack {
            if let errorMessage = errorMessage {
                HStack {
                    Text(errorMessage)
                        .font(.josefinSansRegular(18))
                        .foregroundColor(.errorRed)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                        .padding()
                        .padding(.horizontal, -16)

                    Spacer()
                }
            } else {
                HStack(alignment: .center, spacing: 15) {
                    KFImage(track.imageURL)
                        .placeholder {
                            Color.gray
                                .frame(width: 60, height: 60)
                                .cornerRadius(12)
                        }
                        .cacheOriginalImage(true)
                        .fade(duration: 0.25)
                        .resizable()
                        .frame(width: 60, height: 60)
                        .cornerRadius(12)
                        .aspectRatio(contentMode: .fill)

                    VStack(alignment: .leading, spacing: 8) {
                        Text(track.name ?? AutoSpotoConstants.Strings.TRACK_NAME_METADATA_PLACEHOLDER)
                            .font(.josefinSansRegular(18))
                            .foregroundColor(.textPrimary)

                        Text(track.artist ?? AutoSpotoConstants.Strings.TRACK_ARTIST_METADATA_PLACEHOLDER)
                            .font(.josefinSansLight(18))
                            .foregroundColor(.textPrimary)
                    }

                    Spacer()

                    VStack {
                        Text(track.timeStamp ?? AutoSpotoConstants.Strings.TRACK_TIME_STAMP_METADATA_PLACEHOLDER)
                            .font(.josefinSansLight(16))
                            .foregroundColor(.textPrimary)

                        Spacer()
                    }
                }
                .multilineTextAlignment(.leading)
            }


            Divider()
        }
        .padding(.horizontal, 16)
        .frame(maxHeight: 80)
        .redacted(reason: trackMetadataIsLoading ? .placeholder : [])
    }

}
