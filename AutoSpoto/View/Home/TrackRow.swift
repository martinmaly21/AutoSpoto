//
//  TrackRow.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-02-10.
//

import SwiftUI


struct TrackRow: View {
    //for now this track will always be a spotify URL
    let track: Track

    var body: some View {
        VStack {
            if track.errorFetchingMetadata {
                let errorString = String.localizedStringWithFormat(
                    AutoSpotoConstants.Strings.ERROR_FETCHING_TRACK_METADATA,
                    track.url.absoluteString
                )
                Text(errorString)
                    .font(.josefinSansRegular(18))
                    .foregroundColor(.red)
            } else {
                HStack(alignment: .center, spacing: 15) {
                    AsyncImage(
                        url: track.imageURL,
                        content: { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: 60, maxHeight: 60)
                                .background(Color.gray)
                                .cornerRadius(12)
                        },
                        placeholder: {
                            ProgressView()
                        }
                    )

                    VStack(alignment: .leading, spacing: 8) {
                        Text(track.title ?? AutoSpotoConstants.Strings.TRACK_NAME_METADATA_PLACEHOLDER)
                            .font(.josefinSansRegular(18))
                            .foregroundColor(.white)

                        Text(track.artist ?? AutoSpotoConstants.Strings.TRACK_ARTIST_METADATA_PLACEHOLDER)
                            .font(.josefinSansLight(18))
                            .foregroundColor(.gray)
                    }

                    Spacer()
                }
                .multilineTextAlignment(.leading)
            }


            Divider()
        }
        .padding([.leading, .trailing], 16)
        .frame(maxHeight: 80)
        .redacted(reason: track.isFetchingMetadata ? .placeholder : [])
    }

}
