import SwiftUI

struct UtilitiesBar: View {
    var body: some View {
        HStack {
            Spacer()
            UtilitiesMenu()
        }.padding(EdgeInsets(top: 6, leading: 0, bottom: 6, trailing: 0))
            .background(Color.black)
    }
}
