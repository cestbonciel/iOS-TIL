

import SwiftUI

struct SearchView: View {
  @FetchRequest(
    sortDescriptors: [
      NSSortDescriptor(
        keyPath: \Gem.timestamp,
        ascending: true)
    ],
    animation: .default
  )
  private var gems: FetchedResults<Gem>

  var body: some View {
    Text("To Do")
  }
}

struct SearchView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      SearchView()
    }
    .environment(
      \.managedObjectContext,
      PersistenceController.preview.container.viewContext
    )
  }
}
