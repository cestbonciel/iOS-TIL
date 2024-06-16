//
//  ContentView.swift
//  SwiftUIExam1007
//
//  Created by Seohyun Kim on 2023/10/07.
//

import SwiftUI

struct ContentView: View {
	@State private var bgColor =
	Color(.sRGB, red: 0.98, green: 0.9, blue: 0.2)
//	@State private var titleLabel = UILabel
    var body: some View {
			VStack {
				
				Label("Pick the color", systemImage: "paintpalette.fill ")
				
				
				Image(systemName: "applewatch.watchface")
					.resizable()
					.scaledToFit()
					.padding(24)
					.background(bgColor)
					
				
				Button("Touch") {
					
				}
				
				ColorPicker("Color Variation", selection: $bgColor)
			}
			
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
