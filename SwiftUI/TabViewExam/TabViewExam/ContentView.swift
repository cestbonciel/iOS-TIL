//
//  ContentView.swift
//  TabViewExam
//
//  Created by Seohyun Kim on 2023/10/24.
//

import SwiftUI

struct ContentView: View {
	@State private var selectedTab: Int = 0
	
    var body: some View {
        VStack {
            Button(action: { selectedTab = 1}, label: {Text("Change Red Tab")}
				)
			  TabView(selection: $selectedTab) {
				  Rectangle()
					  .fill(Color.green)
					  .tabItem {
						  Label("Green", systemImage: "music.note")
					  }
					  .tag(0)
				  Rectangle()
					  .fill(Color.red)
					  .tabItem {
						  Label("Red", systemImage: "video")
					  }
					  .tag(1)
			  }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
