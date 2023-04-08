import SwiftUI
import AVFAudio

struct PlayButton: View {
    @EnvironmentObject var mix: MixData
    
    var body: some View {
        Button(action: {
            mix.play()
        }, label: {
             Image(systemName: "play.fill")
                .font(.title2)
                .foregroundColor(mix.players.paused == false ? Color.green : Color.white)
        }).alert(isPresented: $mix.noAudio) {
            Alert(title: Text("No audio is loaded"))
        }

    }
}
