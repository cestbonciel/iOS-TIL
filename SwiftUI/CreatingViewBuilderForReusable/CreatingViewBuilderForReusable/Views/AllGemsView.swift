//
//  SwiftUIView.swift
//  CreatingViewBuilderForReusable
//
//  Created by Seohyun Kim on 2023/09/16.
//

import SwiftUI

struct AllGemsView: View {
	@FetchRequest(
		sortDescriptors: [
			NSSortDescriptor(keyPath: \Gem.timestamp, ascending: true)
		],
		animation: .default
	)
	private var gems: FetchedResults<Gem>
	
    var body: some View {
			List {
				ForEach(gems) { gem in
					NavigationLink(destination: DetailsView(gem: gem)) {
						
					}
				}
			}
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        AllGemsView()
    }
}
