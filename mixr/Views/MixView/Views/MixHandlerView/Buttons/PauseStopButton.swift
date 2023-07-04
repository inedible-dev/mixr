import SwiftUI
import AVFAudio

struct PauseStopButton: View {
    @EnvironmentObject var mix: MixData
    
    var body: some View {
        Button(action: mix.pause, label: {
            Image(systemName: "stop.fill")
                .font(.title2)
        })
    }
}
