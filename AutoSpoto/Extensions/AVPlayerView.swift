//
//  AVPlayerView.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-06-13.
//

import AVKit

//Hide controls for all AVPlayers in app. Not an ideal solution, but at least it allows me to use the native VideoPlayer SwiftUI view
extension AVPlayerView {
    open override func layout() {
        super.layout()
        self.controlsStyle = .none
    }
}
