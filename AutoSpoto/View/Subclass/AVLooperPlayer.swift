//
//  AVLooperPlayer.swift
//  AutoSpoto
//
//  Created by Martin Maly on 2023-06-14.
//

import AVKit

class AVLooperPlayer: AVQueuePlayer {
    private var looper: AVPlayerLooper!

    convenience override init(url: URL) {
        let playerItem = AVPlayerItem(url: url)
        self.init(playerItem: playerItem)
        looper = AVPlayerLooper(player: self, templateItem: playerItem)
    }
}
