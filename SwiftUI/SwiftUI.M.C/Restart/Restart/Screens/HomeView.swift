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
				Text("Home")
					.font(.largeTitle)
				
				Button {
					isOnboardingViewActive = true
				} label: {
					Text("Restart")
				}

			}
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
