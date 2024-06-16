
import SwiftUI

struct FavoriteGems: View {
  @FetchRequest(
    sortDescriptors: [
      NSSortDescriptor(
        keyPath: \Gem.timestamp,
        ascending: true)
    ],
    predicate: NSPredicate(format: "favorite == true"),
    animation: .default
  )
  private var gems: FetchedResults<Gem>

  var body: some View {
    List {
      if gems.isEmpty {
        EmptyFavoriteMessage()
      }
      ForEach(gems) { gem in
        NavigationLink(destination: DetailsView(gem: gem)) {
          GemRow(gem: gem)
        }
      }
    }
    .navigationTitle("Favorites")
  }
}

struct FavoriteGems_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      FavoriteGems()
    }
  }
}
