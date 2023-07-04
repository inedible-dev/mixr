import SwiftUI
import AVFAudio

struct MixHandlerView: View {
    @EnvironmentObject var mix: MixData
    
    var body: some View {
        HStack {
            HStack(spacing: 25) {
                AddButton()
                if(mix.selectedTrack != nil && mix.data.count > 1) {
                    DeleteButton()
                }
                Spacer()
            }.inExpandingRectangle()
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
            PlayDurationView()
            Spacer()
            HStack(spacing: 36) {
                Spacer()
                PauseStopButton()
                PlayButton()
            }.inExpandingRectangle()
                .fixedSize(horizontal: false, vertical: true)
        }.padding()
            .foregroundColor(.white)
    }
}

extension View {
    func inExpandingRectangle() -> some View {
        ZStack {
            Rectangle()
                .fill(Color.clear)
            self
        }
    }
}
