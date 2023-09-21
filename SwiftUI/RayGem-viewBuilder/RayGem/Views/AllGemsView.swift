

import SwiftUI

struct AllGemsView: View {
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
    List {
      ForEach(gems) { gem in
        NavigationLink(destination: DetailsView(gem: gem)) {
          GemRow(gem: gem)
        }
      }
    }
    .navigationTitle("Gems")
  }
}

struct AllGemsView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      AllGemsView()
    }
    .environment(
      \.managedObjectContext,
      PersistenceController.preview.container.viewContext
    )
  }
}
