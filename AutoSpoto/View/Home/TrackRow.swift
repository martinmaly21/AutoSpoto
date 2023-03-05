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
        guard let errorFetchingMetadata = track.errorFetchingMetadata else {
            return nil
        }
        switch errorFetchingMetadata {
        case .error404:
            return String.localizedStringWithFormat(
                AutoSpotoConstants.Strings.ERROR_INVALID_TRACK_URL,
                track.url.absoluteString
            )
        case .miscError:
            return String.localizedStringWithFormat(
                AutoSpotoConstants.Strings.ERROR_FETCHING_TRACK_METADATA,
                track.url.absoluteString
            )
        }
    }

    var body: some View {
        let trackMetadataIsLoading = (!track.isFetchingMetadata && !track.hasFetchedMetadata) || track.isFetchingMetadata

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
                        Text(track.title ?? AutoSpotoConstants.Strings.TRACK_NAME_METADATA_PLACEHOLDER)
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
                .multilineTextAlignment(.leading)
                .onAppear {
                    Task {
                        await homeViewModel.fetchTrackMetadata(chat: chat, track: track)
                    }
                }
                .onDisappear {
                    homeViewModel.cancelTrackMetadataFetchIfNeeded(chat: chat, track: track)
                }
            }


            Divider()
        }
        .padding(.horizontal, 16)
        .frame(maxHeight: 80)
        .redacted(reason: trackMetadataIsLoading ? .placeholder : [])
    }

}
