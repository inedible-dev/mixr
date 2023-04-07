import SwiftUI

struct UtilitiesMenu: View {
    @EnvironmentObject var mix: MixData
    
    @State var clearMixerAlert = false
    
    var body: some View {
        Menu {
            Button(action: {
                mix.showTutorial()
            }) {
                Label("Show Tutorial", systemImage: "doc.text.fill")
            }
            Button(action: {
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
                Alert(title: Text("Clear Mixer"), message: Text("Press Continue to reinitialize the mixer"), primaryButton: Alert.Button.cancel(), secondaryButton: Alert.Button.destructive(Text("Continue")) {
                    mix.resetData()
                })
            }
    }
}
