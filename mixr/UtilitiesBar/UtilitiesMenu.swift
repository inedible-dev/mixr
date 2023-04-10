import SwiftUI

struct UtilitiesMenu: View {
    @EnvironmentObject var mix: MixData
    
    @State private var clearMixerAlert = false
    @State private var isPlayingBefore = false
    
    var body: some View {
        Menu {
            Button(action: {
                mix.showTutorial()
            }) {
                Label("Show Tutorial", systemImage: "doc.text.fill")
            }
            Button(action: {
                if !mix.players.paused {
                    mix.timer.stop()
                    isPlayingBefore.toggle()
                }
                clearMixerAlert = true
            }) {
                Label("Clear Mixer", systemImage: "clear.fill")
            }
        } label: {
            Image(systemName: "ellipsis.circle.fill")
                .font(.title2)
                .foregroundColor(.white)
        }.padding()
            .alert(isPresented: $clearMixerAlert) {
                Alert(title: Text("Clear Mixer"), message: Text("Press Continue to reinitialize the mixer"), primaryButton: .cancel({
                    if isPlayingBefore {
                        mix.startTimer()
                        isPlayingBefore.toggle()
                    }
                }), secondaryButton: .destructive(Text("Continue")) {
                    mix.resetData()
                })
            }
    }
}
