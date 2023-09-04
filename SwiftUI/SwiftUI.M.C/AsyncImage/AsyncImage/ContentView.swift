//
//  ContentView.swift
//  AsyncImage
//
//  Created by Seohyun Kim on 2023/09/05.
//

import SwiftUI

extension Image {
	func imageModifier() -> some View {
		self
			.resizable()
			.scaledToFit()
	}
	
	func iconModifier() -> some View {
		self
			.imageModifier()
			.frame(maxWidth: 128)
			.foregroundColor(.purple)
			.opacity(0.5)
	}
}

struct ContentView: View {
	private let imageURL: String = "https://images.unsplash.com/photo-1592093474530-86874167e896?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1901&q=80"
    var body: some View {
		VStack {
			Text("Space")
				.font(.system(size: 40))
				.fontWeight(.black)
				.foregroundStyle(
					LinearGradient(
						colors: [.purple, .blue, .black],
						startPoint: .topLeading,
						endPoint: .bottomTrailing)
				)
				
			//MARK: -1.Basic
		    //AsyncImage(url: URL(string: imageURL))
			//MARK: - 2.Scale
			//AsyncImage(url: URL(string: imageURL), scale: 8.0)
			/*
			AsyncImage(url: URL(string: imageURL2)) { image in
				image.imageModifier()
				
			} placeholder: {
				Image(systemName: "photo.circle.fill").iconModifier()
			}
			.padding(40)
			*/
			// MARK: - 4. PHASE
			/*
			AsyncImage(url: URL(string:imageURL)) { phase in
				//SUCCESS: The image successfully loaded.
				// Failure: The image failed to load with an error.
				if let image = phase.image {
					image.imageModifier()
				} else if phase.error != nil {
					Image(systemName: "ant.circle.fill").iconModifier()
				} else {
					Image(systemName: "photo.circle.fill").iconModifier()
				}
			}
			.padding(40)
			*/
			// MARK: - 5. Animation
			AsyncImage(url: URL(string: imageURL), transaction: Transaction(animation: .spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.25))) { phase in
				switch phase {
				case .success(let image):
					image
						.imageModifier()
						//.transition(.move(edge: .bottom))
						//.transition(.slide)
						.transition(.scale)
				case .failure(_):
					Image(systemName: "ant.circle.fill").iconModifier()
				case .empty:
					Image(systemName: "photo.circle.fill").iconModifier()
				@unknown default:
					ProgressView()
				}
			}
			.padding(40)
		}
    }
		
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
