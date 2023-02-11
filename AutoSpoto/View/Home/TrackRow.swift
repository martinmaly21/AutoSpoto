//
//  TrackRow.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-02-10.
//

import SwiftUI

struct TrackRow: View {
    //for now this track will always be a spotify URL
    let track: URL

    var body: some View {
        Text(track.absoluteString)
    }
}
