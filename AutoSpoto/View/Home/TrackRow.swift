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
    
    private var isTrackUploaded: Bool? {
        guard let lastUpdated = chat.lastUpdated else {
            return nil
        }
        
        return track.timeStamp < lastUpdated
    }
    
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
                            .lineLimit(1)
                        
                        Text(AutoSpotoConstants.Strings.ERROR_FETCHING_TRACK_METADATA)
                            .font(.josefinSansLight(18))
                            .foregroundColor(.textPrimary)
                    } else {
                        Text(track.name ?? AutoSpotoConstants.Strings.TRACK_NAME_METADATA_PLACEHOLDER)
                            .font(.josefinSansRegular(18))
                            .foregroundColor(.textPrimary)
                            .lineLimit(1)
                        
                        Text(track.artist ?? AutoSpotoConstants.Strings.TRACK_ARTIST_METADATA_PLACEHOLDER)
                            .font(.josefinSansLight(18))
                            .foregroundColor(.textPrimary)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    HStack {
                        Text(track.timeStamp.formatted())
                            .font(.josefinSansLight(16))
                            .foregroundColor(.textPrimary)
                    }
                    
                    Spacer()
                    
                    if let isTrackUploaded = isTrackUploaded {
                        Text(isTrackUploaded ? AutoSpotoConstants.Strings.SYNCED : AutoSpotoConstants.Strings.NOT_SYNCED)
                            .font(.josefinSansLight(18))
                            .foregroundColor(isTrackUploaded ? Color.spotifyGreen : Color.red)
                    }
                    
                }
            }
            .multilineTextAlignment(.leading)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, -2)
        .redacted(reason: trackMetadataIsLoading ? .placeholder : [])
        
        Divider()
            .padding(.horizontal, 16)
            .frame(maxHeight: 50)
    }
}
