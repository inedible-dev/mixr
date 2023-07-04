import SwiftUI

struct TutorialView: View {
    var dismiss: () -> Void
    
    var body: some View {
        ZStack {
            Color.init(white: 0.15).edgesIgnoringSafeArea(.all)
            VStack(spacing: 25) {
                VStack {
                    Text("Welcome to mixr")
                        .font(.system(size: 40, weight: .semibold))
                    Text("Quickly test your mix in a flash.")
                        .font(.system(size: 14))
                }
                Image("template-simulator")
                    .resizable()
                    .scaledToFit()
                    .padding()
                Button(action: {
                    dismiss()
                }, label: {
                    Text("Continue")
                        .frame(maxWidth: 500)
                        .padding(EdgeInsets(top: 12, leading: 0, bottom: 12, trailing: 0))
                        .font(.system(size: 16, weight: .medium))
                        .background(Color.blue)
                        .cornerRadius(10)
                })
            }.padding(32)
                .foregroundColor(.white)
        }
    }
}
