

import SwiftUI

struct MainColorText: View {
  let colorName: String

  var body: some View {
    Text("Main color: ") +
      Text(colorName.capitalized)
        .foregroundColor(Color(colorName))
        .bold()
        .font(.subheadline)
  }
}

struct MainColorText_Previews: PreviewProvider {
  static var previews: some View {
    MainColorText(colorName: "rose")
      .padding()
      .previewLayout(.sizeThatFits)
  }
}
