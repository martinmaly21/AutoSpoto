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
    
    let track: Track

    private var errorMessage: String? {
        guard track.errorFetchingTrackMetadata else {
            return nil
        }

        return String.localizedStringWithFormat(
            AutoSpotoConstants.Strings.ERROR_FETCHING_TRACK_METADATA,
            track.url.absoluteString
        )
    }

    var body: some View {
        let trackMetadataIsLoading = !track.errorFetchingTrackMetadata && !track.metadataHasBeenFetched

        VStack(spacing: 0) {
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
                                .frame(width: 60, height: 40)
                                .cornerRadius(8)
                        }
                        .cacheOriginalImage(true)
                        .fade(duration: 0.25)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 40)
                        .cornerRadius(8)
                        .aspectRatio(contentMode: .fill)

                    VStack(alignment: .leading, spacing: 0) {
                        Text(track.name ?? AutoSpotoConstants.Strings.TRACK_NAME_METADATA_PLACEHOLDER)
                            .font(.josefinSansRegular(18))
                            .foregroundColor(.textPrimary)

                        Text(track.artist ?? AutoSpotoConstants.Strings.TRACK_ARTIST_METADATA_PLACEHOLDER)
                            .font(.josefinSansLight(18))
                            .foregroundColor(.textPrimary)
                    }

                    Spacer()

                    VStack {
                        Text(track.timeStamp)
                            .font(.josefinSansLight(16))
                            .foregroundColor(.textPrimary)

                        Spacer()
                    }
                }
                .padding(.bottom, 4)
                .multilineTextAlignment(.leading)
            }


            Divider()
        }
        .padding(.bottom, -4)
        .padding(.horizontal, 16)
        .frame(maxHeight: 50)
        .redacted(reason: trackMetadataIsLoading ? .placeholder : [])
    }

}
