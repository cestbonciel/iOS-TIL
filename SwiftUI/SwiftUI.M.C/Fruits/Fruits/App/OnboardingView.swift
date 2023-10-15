//
//  OnboardingView.swift
//  Fruits
//
//  Created by Seohyun Kim on 2023/10/15.
//

import SwiftUI

struct OnboardingView: View {
	//MARK: - PROPERTIES
	//MARK: - BODY
	
	
    var body: some View {
		 TabView {
			 ForEach(0..<5) { item in
				 FruitCardView()
			 } //: LOOP
			 FruitCardView()
		 }//:TabView
		 .tabViewStyle(PageTabViewStyle())
		 .padding(.vertical, 20)
    }
}
//MARK: - PREVIEW
struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
