import SwiftUI
import AVFAudio

struct PlayDurationView: View {
    @EnvironmentObject var mix: MixData
    
    func getZeroDigit(_ number: Int) -> String {
        return number < 10 ? "0" + String(number) : String(number)
    }
    
    var body: some View {
        Text("\(getZeroDigit(Int(mix.players.syncTime.current) / 60)):\(getZeroDigit(Int(mix.players.syncTime.current) % 60))")
            .font(.largeTitle)
    }
}
