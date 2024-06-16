

import SwiftUI

struct GemRow: View {
  @ObservedObject var gem: Gem

  var body: some View {
    HStack {
      Image(gem.imageName)
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(width: 64, height: 64)
        .mask(Circle())
      VStack(alignment: .leading) {
        Text(gem.name)
          .font(.title)
          .bold()
        MainColorText(colorName: gem.mainColor)
      }
    }
  }
}

struct GemRow_Previews: PreviewProvider {
  static var previews: some View {
    List {
      GemRow(gem: roseGem)
      GemRow(gem: lapisGem)
    }
  }
}
