import Foundation
import AVFAudio
import SwiftUI

struct AudioPlayer {
    var paused: Bool = true
    var syncTime = SyncTime()
    var player: [Player] = []
}

struct Player: Identifiable {
    var id: String
    var node: AVAudioPlayer?
    var currentdB: Float = -70.0
}

struct SyncTime {
    var uuid: String?
    var current: Double = 0
    var time: Double?
}
