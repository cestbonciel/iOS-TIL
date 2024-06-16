//
//  ContentView.swift
//  viewBuilderTest
//
//  Created by Seohyun Kim on 2023/09/16.
//

import SwiftUI

struct ContentView: View {
	var body: some View {
		
			NavigationView {
				
				VStack {
					HStack {
						Text("iOS 17")
							.font(.title2)
							.fontWeight(.black)
							.padding(24)
					}
					
					MyVStack {
						Text("iPhone 13 pro")
						Text("iPhone 14 pro")
						Text("iPhone 15 pro")
					} //: MyVStack
					
					HStack {
						Image(systemName: "iphone.gen2")
						Image(systemName: "iphone")
						Image(systemName: "iphone")
					}//: HStack
					.padding(10)
					.font(.largeTitle)
					Spacer()
					//Custom View
//					VStack {
//						AlertView {
//							Image(systemName: "exclamationmark.shield.fill")
//								.resizable()
//								.frame(width: 65, height: 65)
//							Text("Here is a custom alert with viewBuilder.")
//						}
//					}
				}//: VStack
				.navigationTitle("View Builder")
				.padding(24)
			} //: NavigationView
	}
}

struct AlertView<Content: View>: View {
	let content: Content
	
	init(@ViewBuilder content: () -> Content) {
		self.content = content()
	}
	var body: some View {
		VStack {
			content
				.padding()
			
			HStack {
				Button(action: {}) {
					Text("Cancel")
						.bold()
						.foregroundColor(.red)
				}
				
				Spacer()
				
				Button(action: {}) {
					Text("Confirm")
						.bold()
						.foregroundColor(.white)
				}
				
			}// : HStack
			.padding()
		}//: VStack
		.frame(width: UIScreen.main.bounds.size.width / 2)
		.background(Color.blue)
		.cornerRadius(10)
		.padding()
		
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
