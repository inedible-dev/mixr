import SwiftUI
import AVFAudio

struct PauseButton: View {
    @EnvironmentObject var mix: MixData
    
    var body: some View {
        Button(action: mix.pause, label: {
            Image(systemName: "stop.fill")
                .font(.title2)
        })
    }
}
