//
//  AudioPlayer.swift
//  mixr
//
//  Created by Wongkraiwich Chuenchomphu.
//

import Foundation
import AVFAudio
import SwiftUI

struct Player: Identifiable {
    var id: String
    var node: AVAudioPlayer?
    var currentdB: Float = -70.0
}
