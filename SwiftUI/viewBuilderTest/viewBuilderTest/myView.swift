//
//  myView.swift
//  viewBuilderTest
//
//  Created by Seohyun Kim on 2023/09/16.
//

import SwiftUI

struct myView: View {
    var body: some View {
        Circle()
				.foregroundStyle(
					LinearGradient(
						colors: [.indigo, .cyan],
						startPoint: .topLeading,
						endPoint: .bottomTrailing
					)
				)
				.padding(30)
    }
}

struct myView_Previews: PreviewProvider {
    static var previews: some View {
        myView()
    }
}
