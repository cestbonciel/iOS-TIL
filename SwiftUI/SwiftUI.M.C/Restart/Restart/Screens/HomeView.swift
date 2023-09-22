//
//  HomeView.swift
//  Restart
//
//  Created by Seohyun Kim on 2023/09/21.
//

import SwiftUI

struct HomeView: View {
	//MARK: - Property
	
	@AppStorage("onboarding") var isOnboardingViewActive: Bool = false
	//MARK: - Body
    var body: some View {
			VStack(spacing: 20) {
				//MARK: - HEADER
				
				Spacer()
				
				// This image has copyright 2020 © Seohyun Kim all right reserved.
				ZStack {
					CircleGroupView(shapeColor: .gray, shapeOpacity: 0.1)
					Image("IMG_8622")
						.resizable()
						.scaledToFit()
					.padding(80)
				}
				
				//MARK: - CENTER
				Text("""
			 Art is the lie that enables us to realize the truth.
			 - Pablo Picsso
			""")
				.font(.title3)
				.fontWeight(.light)
				.foregroundColor(.secondary)
				.multilineTextAlignment(.center)
				.padding()
					
				//MARK: - FOOTER
				
				Spacer()
				
				Button {
					isOnboardingViewActive = true
				} label: {
					Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
						.imageScale(.large)
					
					Text("Restart")
						.font(.system(.title3, design: .rounded))
						.fontWeight(.bold)
				}//: Button
				.buttonStyle(.borderedProminent)
				.buttonBorderShape(.capsule)
				.controlSize(.large)

			}
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
