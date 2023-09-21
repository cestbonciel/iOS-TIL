
import SwiftUI

struct ContentView: View {
  var body: some View {
    TabView {
      NavigationView {
        AllGemsView()
      }
      .tabItem {
        Label("All", systemImage: "list.bullet")
      }

      NavigationView {
        FavoriteGems()
      }
      .tabItem {
        Label("Favorites", systemImage: "heart")
      }

      NavigationView {
        SearchView()
      }
      .tabItem {
        Label("Search", systemImage: "magnifyingglass")
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
      .environment(
        \.managedObjectContext,
        PersistenceController.preview.container.viewContext
      )
  }
}
