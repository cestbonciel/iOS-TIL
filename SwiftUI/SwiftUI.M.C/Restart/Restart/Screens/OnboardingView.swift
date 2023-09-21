//
//  OnboardingView.swift
//  Restart
//
//  Created by Seohyun Kim on 2023/09/21.
//

import SwiftUI

struct OnboardingView: View {
	// MARK: - Property
	
	@AppStorage("onboarding") var isOnboardingViewActive: Bool = true
	
	// MARK: - Body
    var body: some View {
			VStack {
				Text("Onboarding")
					.font(.largeTitle)
				
				Button {
					isOnboardingViewActive = false
				} label: {
					Text("Start")
				}

			}// : VStack
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
