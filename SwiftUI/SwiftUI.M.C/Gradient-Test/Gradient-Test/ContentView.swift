//
//  ContentView.swift
//  Gradient-Test
//
//  Created by Seohyun Kim on 2023/09/05.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("iOS")
				.font(.system(size: 160))
				.fontWeight(.bold)
				.foregroundStyle(
					LinearGradient(
						colors: [.green, .cyan, .blue],
						startPoint: .topLeading,
						endPoint: .bottomTrailing)
				)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
