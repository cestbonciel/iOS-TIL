/// Copyright (c) 2021 Razeware LLC

import SwiftUI

struct DetailsView: View {
  @Environment(\.managedObjectContext) private var viewContext
  @ObservedObject var gem: Gem

  var body: some View {
    ScrollView {
      VStack(spacing: 10) {
        Image(gem.imageName)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 200, height: 200)
        Text(gem.name)
          .foregroundColor(Color(gem.mainColor))
          .font(.largeTitle)
          .bold()
        Text(gem.info)
          .multilineTextAlignment(.leading)
          .frame(maxWidth: .infinity, alignment: .leading)
        Divider()
        VStack(alignment: .leading) {
          MainColorText(colorName: gem.mainColor)
          Text("Crystal system: \(gem.crystalSystem)")
          Text("Chemical formula: \(gem.formula)")
          Text("Hardness (Mohs hardness scale): \(gem.hardness)")
          Text("Transparency: \(gem.transparency)")
        }
        .font(.subheadline)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top)
      }
      .padding()
    }
    .navigationTitle(gem.name)
    .toolbar {
      ToolbarItem {
        Button(action: toggleFavorite) {
          Label(
            gem.favorite ? "Unfavorite" : "Favorite",
            systemImage: gem.favorite ? "heart.fill" : "heart"
          )
          .foregroundColor(.pink)
        }
      }
    }
  }

  func toggleFavorite() {
    gem.favorite.toggle()
    try? viewContext.save()
  }
}

struct DetailsView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      DetailsView(gem: roseGem)
    }
    .environment(
      \.managedObjectContext,
      PersistenceController.preview.container.viewContext
    )
  }
}
