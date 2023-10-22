//
//  FruitsApp.swift
//  Fruits
//
//  Created by Seohyun Kim on 2023/10/15.
//

import SwiftUI

@main
struct FruitsApp: App {
	@AppStorage("isOnboarding") var isOnboarding: Bool = true
	
	var body: some Scene {
	  WindowGroup {
		 if isOnboarding {
			OnboardingView()
		 } else {
			ContentView()
		 }
	  }
	}
}
