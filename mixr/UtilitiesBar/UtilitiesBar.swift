import SwiftUI

struct UtilitiesBar: View {
    var body: some View {
        HStack {
            Spacer()
            UtilitiesMenu()
        }.frame(maxWidth: .infinity, minHeight: 50)
            .background(Color.black)
    }
}
