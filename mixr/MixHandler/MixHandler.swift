import SwiftUI
import AVFAudio

struct MixHandler: View {
    @EnvironmentObject var mix: MixData
    
    var body: some View {
        HStack {
            HStack(spacing: 25) {
                AddTrack()
                if(mix.selectedTrack != nil && mix.data.count > 1) {
                    DeleteTrack()
                }
                Spacer()
            }.inExpandingRectangle()
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
            PlayTime()
            Spacer()
            HStack(spacing: 36) {
                Spacer()
                PauseButton()
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
