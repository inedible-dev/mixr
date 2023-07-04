import SwiftUI
import AVFAudio

struct VolumeSlider: View {
    @Binding var gain: Float
    var changeVolume: (_ gain: Float) -> Void
    
    var body: some View {
        GeometryReader {
            point in
            Slider(value: $gain, in: -70.0...6.0, step: 0.1)
                .rotationEffect(.degrees(-90.0), anchor: .topLeading)
                        .frame(width: point.size.height)
                        .offset(y: point.size.height)
                        .onChange(of: gain) {_ in
                            changeVolume(gain)
                        }.tint(.blue)
        }
    }
}
