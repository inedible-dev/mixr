import SwiftUI

@main
struct MyApp: App {
    @StateObject var mix = MixData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .background(Color.init(white: 0.2))
                .preferredColorScheme(.dark)
                .environmentObject(mix)
        }
    }
}
