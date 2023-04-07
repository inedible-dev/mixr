import SwiftUI

struct DeleteTrack: View {
    @EnvironmentObject var mix: MixData
    @Environment(\.horizontalSizeClass) private var sizeClass
    
    @State var deleteAlert = false
    
    var body: some View {
        let compact = sizeClass == .compact
        
        Button(action: {
            deleteAlert.toggle()
        }, label: {
            HStack(spacing: 6){
                Image(systemName: "trash.fill")
                    .font(.title2)
                if(!compact) {
                    Text("Delete Track")
                        .font(.title3)
                        .fontWeight(.medium)
                }
            }
        }).alert(isPresented: $deleteAlert) {
                Alert(title: Text("Delete This Track"), message: Text("Press Continue to delete this track"), primaryButton: .cancel(), secondaryButton: .destructive(Text("Continue")) {
                    mix.deleteTrack()
                })
            }
    }
}
