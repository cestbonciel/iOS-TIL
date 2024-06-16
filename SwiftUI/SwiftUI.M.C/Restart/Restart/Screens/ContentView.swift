//
//  ContentView.swift
//  Restart
//
//  Created by Seohyun Kim on 2023/09/21.
//

import SwiftUI

struct ContentView: View {
	// @AppStorage - Property Wrapper
	@AppStorage("onboarding") var isOnboardingViewActive: Bool = true
	//onboarding -> User Defaults Key - unique key
    var body: some View {
			ZStack {
				if isOnboardingViewActive {
					OnboardingView()
				} else {
					HomeView()
				}
			}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
