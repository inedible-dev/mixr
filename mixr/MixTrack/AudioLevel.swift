import SwiftUI

struct AudioLevel: View {
    var amplitude: Float
    
    var body: some View {
        GeometryReader {
            geometry in
                ZStack(alignment: .bottom){
                    Rectangle()
                        .fill(LinearGradient(gradient: Gradient(colors: [.red, .yellow, .green]), startPoint: .top, endPoint: .center))
                    Rectangle()
                        .fill(Color.black)
                        .mask(Rectangle().padding(.bottom, geometry.size.height * CGFloat(self.amplitude)))
                        .animation(.easeOut, value: 0.15)
                }.padding(geometry.size.width * 0.1)
                .frame(maxHeight: geometry.size.height)
        }
    }
    
}
