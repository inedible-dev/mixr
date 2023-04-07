import SwiftUI
import AVFAudio

struct MixTrack: View {
    
    @EnvironmentObject var mix: MixData
    @Binding var data: MixControl
    
    func gainText(_ gain: Float) -> String {
        let sGain = String(format: "%.1f", gain)
        if(sGain == "-70.0") {
            return "-inf"
        } 
        return "\(sGain)"
    }

    var body: some View {
        VStack(alignment: .center, spacing: 25) {
            AddDocument(id: data.id, fileURL: data.url)
            VStack(spacing: 15) {
                Text(gainText(data.gain))
                    .padding(10)
                    .frame(maxWidth: .infinity)
                    .background(Color.gray)
                HStack(spacing: 10) {
                    AudioLevel(amplitude: mix.getAmplitude(id: data.id))
                        .frame(width: 15)
                    VSlider(gain: $data.gain) {
                        gain in
                        mix.setVolume(gain: gain, id: data.id)
                    }
                        .onTapGesture(count: 2, perform: {
                            data.gain = 0
                        })
                }
                .frame(width: 55, alignment: .center)
                TextField("New Track", text: $data.name)
                    .multilineTextAlignment(.center)
                
            }.padding()
                .font(.title2)
        }
        .ignoresSafeArea()
        .frame(width: 125)
        .background(Color.init(white: data.id == mix.selectedTrack ? 0.35 : 0.25))
        .overlay(Rectangle().frame(width: 2).foregroundColor(Color.init(white: 0.5)), alignment: .trailing)
    }
}
