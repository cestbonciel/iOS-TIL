import SwiftUI

struct GemList: View {
	let gems: [Gem]
	let showMessage: Bool
	
	var body: some View {
		List {
			ForEach(gems) { gem in
				NavigationLink(destination: DetailsView(gem: gem)) {
					GemRow(gem: gem)
				}
			}
			
			if showMessage {
				EmptyFavoriteMessage()
			}
		}
		.listStyle(.insetGrouped)
		
	}
}

//extension GemList where Content == EmptyView {
//	// 2
//	init(_ gems: Data) {
//		// 3
//		self.init(gems) {
//			EmptyView()
//		}
//	}
//}

struct GemList_Previews: PreviewProvider {
	static let gems = [roseGem, lapisGem]

	static var previews: some View {
		// 1
		NavigationView {
			GemList(gems: gems) {
				// 2
				Text("This is at the bottom of the list...")
					.padding()
					.listRowBackground(Color.clear)
					.frame(maxWidth: .infinity)
			}
			.navigationTitle("Gems")
		}
	}
}
