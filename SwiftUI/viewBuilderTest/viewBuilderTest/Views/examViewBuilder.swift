//
//  examViewBuilder.swift
//  viewBuilderTest
//
//  Created by Seohyun Kim on 2023/10/07.
//

import SwiftUI

struct examViewBuilder: View {
    var body: some View {
			MyVStack {
				Text("iPhone 13")
			}
    }
}

struct MyVStack<Content: View>: View {
	
	let content: () -> Content
	init(@ViewBuilder content: @escaping () -> Content) {
		self.content = content
	}
	
	var body: some View {
		
		VStack(spacing: 20) {
			
			
			content()
				.foregroundStyle(
					LinearGradient(
						colors: [.orange, .blue],
						startPoint: .bottomLeading,
						endPoint: .topTrailing)
				)
			
			
		}
		.font(.largeTitle)
		
	}
}

struct examViewBuilder_Previews: PreviewProvider {
    static var previews: some View {
        examViewBuilder()
    }
}
