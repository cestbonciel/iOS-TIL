//
//  ContentView.swift
//  Fruits
//
//  Created by Seohyun Kim on 2023/10/15.
//

import SwiftUI

struct ContentView: View {
	//MARK: - PROPERTIES
	
	@State private var isShowingSettings: Bool = false
	
	var fruits: [Fruit] = fruitsData
	//MARK: - BODY
    var body: some View {
		 NavigationStack {
			 List {
				 ForEach(fruits.shuffled()) { item in
					 NavigationLink(destination: FruitsDetailView(fruit: item)) {
						 FruitRowView(fruit: item)
							 .padding(.vertical, 4)
					 }
				 }
			 }
			 .navigationTitle("Fruits")
			 .navigationBarItems(
				trailing:
					Button(action: {
						isShowingSettings = true
					}, label: {
						Image(systemName: "slider.horizontal.3")
					})//: Button
					.sheet(isPresented: $isShowingSettings, content: {
						SettingsView()
					})
			 )
		 }//: NAVIGATION
		 .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(fruits: fruitsData)
			 .previewDevice("iPhone 11 Pro")
    }
}
