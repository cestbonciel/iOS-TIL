//
//  FruitsDetailView.swift
//  Fruits
//
//  Created by Seohyun Kim on 2023/10/30.
//

import SwiftUI

struct FruitsDetailView: View {
	// MARK: - PROPERTIES
	
	var fruit: Fruit
	
	// MARK: - BODY
	
    var body: some View {
		 NavigationView {
			 ScrollView(.vertical, showsIndicators: false) {
				 VStack(alignment: .center, spacing: 20) {
					 // HEADER
					 FruitsHeaderView(fruit: fruit)
					 VStack(alignment: .leading, spacing: 20) {
						 // TITLE
						 Text(fruit.title)
							 .font(.largeTitle)
							 .fontWeight(.heavy)
							 .foregroundColor(fruit.gradientColors[1])
						 
						 // HEADLINE
						 Text(fruit.headline)
							 .font(.headline)
							 .multilineTextAlignment(.leading)
						 // NUTRIENTS
						 FruitNutrientsView(fruit: fruit)
						 // SUBHEADLINE
						 Text("Learn more about \(fruit.title)".uppercased())
							 .fontWeight(.bold)
							 .foregroundColor(fruit.gradientColors[1])
						 // DESCRIPTION
						 Text(fruit.description)
							 .multilineTextAlignment(.leading)
						 // LINK
						 SourceLinkView()
							 .padding(.top, 10)
							 .padding(.bottom, 40)
					 }//: VSTACK
					 .padding(.horizontal, 20)
					 .frame(maxWidth: 640, alignment: .center)
				 }//: VSTACK
				 .navigationBarTitle(fruit.title, displayMode: .inline)
				 .navigationBarHidden(true)
			 }//: SCROLL
			 .edgesIgnoringSafeArea(.top)
		 } //: Navigation
		 .navigationViewStyle(StackNavigationViewStyle())
    }
}

// MARK: - Preview
struct FruitsDetailView_Previews: PreviewProvider {
    static var previews: some View {
		 FruitsDetailView(fruit: fruitsData[0])
			 .previewDevice("iPhone 13 Pro")
    }
}
