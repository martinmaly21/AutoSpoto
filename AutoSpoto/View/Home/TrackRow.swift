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
    
    var body: some View {
        let trackMetadataIsLoading = !track.errorFetchingTrackMetadata && !track.metadataHasBeenFetched
        
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 15) {
                if track.errorFetchingTrackMetadata {
                    ZStack(alignment: .center) {
                        Rectangle()
                            .fill(.gray)
                        
                        Image(systemName: "exclamationmark.triangle")
                            .resizable()
                            .tint(Color.white)
                        
                            .frame(width: 20, height: 20)
                    }
                    
                    .frame(width: 40, height: 40)
                    .cornerRadius(8)
                } else {
                    KFImage(track.imageURL)
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
                
                VStack(alignment: .leading, spacing: 0) {
                    if track.errorFetchingTrackMetadata {
                        Text(track.url.absoluteString)
                            .font(.josefinSansRegular(18))
                            .foregroundColor(.textPrimary)
                        
                        Text(AutoSpotoConstants.Strings.ERROR_FETCHING_TRACK_METADATA)
                            .font(.josefinSansLight(18))
                            .foregroundColor(.textPrimary)
                    } else {
                        Text(track.name ?? AutoSpotoConstants.Strings.TRACK_NAME_METADATA_PLACEHOLDER)
                            .font(.josefinSansRegular(18))
                            .foregroundColor(.textPrimary)
                        
                        Text(track.artist ?? AutoSpotoConstants.Strings.TRACK_ARTIST_METADATA_PLACEHOLDER)
                            .font(.josefinSansLight(18))
                            .foregroundColor(.textPrimary)
                    }
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
        }
        .padding(.horizontal, 16)
        .padding(.vertical, -2)
        
        Divider()
            .padding(.horizontal, 16)
            .frame(maxHeight: 50)
            .redacted(reason: trackMetadataIsLoading ? .placeholder : [])
    }
}
