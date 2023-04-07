import SwiftUI
import AVFAudio

struct PlayButton: View {
    @EnvironmentObject var mix: MixData
    
    @State var noAudio = false
    
    var body: some View {
        Button(action: {
            mix.play() {
                noAudio = true
            }
        }, label: {
             Image(systemName: "play.fill")
                .font(.title2)
                .foregroundColor(mix.players.paused == false ? Color.green : Color.white)
        }).alert(isPresented: $noAudio) {
            Alert(title: Text("No audio is loaded"))
        }

    }
}
