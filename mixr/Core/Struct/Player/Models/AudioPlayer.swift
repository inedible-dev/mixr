//
//  AudioPlayer.swift
//  mixr
//
//  Created by Wongkraiwich Chuenchomphu on 4/7/23.
//

import Foundation

struct AudioPlayer {
    var paused: Bool = true
    var syncTime = SyncTime()
    var player: [Player] = []
}
