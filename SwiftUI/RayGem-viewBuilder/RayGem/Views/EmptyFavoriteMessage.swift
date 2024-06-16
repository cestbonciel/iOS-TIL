

import SwiftUI

struct EmptyFavoriteMessage: View {
  let heart = Image(systemName: "heart")

  var body: some View {
    VStack(spacing: 8) {
      Image(systemName: "heart.slash.circle.fill")
        .imageScale(.large)
        .font(.largeTitle)
        .foregroundColor(.pink)
      Text(
      """
      You don't have any favorite gems yet.
      Tap \(heart) at the top right when viewing a gem to favorite it.
      """
      )
      .foregroundColor(.secondary)
      .symbolRenderingMode(.multicolor)
      .multilineTextAlignment(.center)
    }
  }
}

struct EmptyFavoriteMessage_Previews: PreviewProvider {
  static var previews: some View {
    EmptyFavoriteMessage()
      .padding()
  }
}
