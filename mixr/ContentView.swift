import SwiftUI
import AVFAudio

struct ContentView: View {
    @EnvironmentObject var mix: MixData
    
    var body: some View {
        ZStack {
            Color.init(white: 0.4).edgesIgnoringSafeArea(.all)
            VStack(spacing: 0){
                UtilitiesBar()
                ScrollView(.horizontal, showsIndicators: false){
                    HStack(spacing: 0) {
                        ForEach($mix.data) {$channel in
                            MixTrack(data: $channel)
                                .onTapGesture {
                                    if(mix.selectedTrack == channel.id) {
                                        mix.selectedTrack = nil
                                    } else {
                                        mix.selectedTrack = channel.id
                                    }
                                }
                        }
                    }
                }.onTapGesture {
                    self.hideKeyboard()
                }.background(Color.init(white: 0.25))
                MixHandler()
            }.onAppear() {
                do {
                    try AVAudioSession.sharedInstance().setCategory(.playback)
                    try AVAudioSession.sharedInstance().setActive(true)
                } catch {
                    print("Failed to initialize session!")
                }
            }.sheet(isPresented: $mix.tutorial, onDismiss: mix.dismissTutorial) {
                TutorialView(dismiss: mix.dismissTutorial)
            }
        }
    }
}
