//
//  ContentView.swift
//  MyApp
//
//  Created by Seohyun Kim on 2023/08/13.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "apple.logo")
                .imageScale(.large)
				.foregroundColor(.gray)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
