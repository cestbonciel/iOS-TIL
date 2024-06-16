//
//  NavigationStackView_Test.swift
//  voiceMemo
//
//  Created by Seohyun Kim on 2023/11/19.
//

import SwiftUI

struct NavigationStackView_Test: View {
	@State var stack = NavigationPath()
	
	
	var body: some View {
		
		NavigationStack(path: $stack) {
			
			NavigationLink("Go To Child View", value: "10")
				.navigationDestination(for: String.self) { value in
					
					VStack {
						
						NavigationLink("Go To Child's Child View", value: "20")
						
						Text("Child Number is \(value)")
						
						Button("Go To Parent View") {
							stack.removeLast()
						}
						.backgroundStyle(.mint)
						
						Button("Go To rootView") {
							stack = .init()
						}
						.backgroundStyle(.orange)
						
					}//: VStack
					
				}//: Navi Destination
		}//: Navigationstack
		
	}
}


struct NavigationStackView_Test_Previews: PreviewProvider {
	static var previews: some View {
		NavigationStackView_Test()
	}
}
