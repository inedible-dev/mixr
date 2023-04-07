import SwiftUI

struct AddTrack: View {
    @EnvironmentObject var mix: MixData
    @Environment(\.horizontalSizeClass) private var sizeClass
    @State var latencyWarning = false
    
    var body: some View {
        let compact = sizeClass == .compact
        
        Button(action: {
            if(mix.data.count < 12) {
                mix.addTrack()
            } else {
                latencyWarning = true
            }
        }, label: {
            HStack(spacing: 6) {
                Image(systemName: "plus.app.fill")
                    .font(.title2)
                if(!compact) {
                    Text("Add Track")
                        .font(.title3)
                        .fontWeight(.medium)
                }
            }
        }).alert(isPresented: $latencyWarning) {
            Alert(title: Text("Volume Warning"), message: Text("Press Continue to add another track"), primaryButton: Alert.Button.cancel(), secondaryButton: Alert.Button.destructive(Text("Continue")) {
                mix.addTrack()
            })
        }
    }
}
