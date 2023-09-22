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
			ZStack {
				Color("ColorGreen")
					.ignoresSafeArea(.all, edges: .all)
				
				VStack {
					// MARK: - HEADER
					
					Spacer()
					
					VStack(spacing: 0) {
						Text("Share.")
							.font(.system(size: 60))
							.fontWeight(.heavy)
							.foregroundColor(.white)
						
						Text("""
			It's not how much we give but
			how much love we put into giving.
			""")
						.font(.title3)
						.fontWeight(.light)
						.foregroundColor(.white)
						.multilineTextAlignment(.center)
						.padding(.horizontal, 10)
					}// : HEADER
					// MARK: - CENTER
					
					ZStack {
						CircleGroupView(shapeColor: .white, shapeOpacity: 0.2)
						
						//  This image has copyright 2020 © Seohyun Kim all right reserved.
						Image("IMG_8624")
							.resizable()
							.scaledToFit()
							.padding(80)
					}//: CETER
					Spacer()
					// MARK: - FOOTER
					ZStack {
						// PARTS OF THE CUSTOM BUTTON
						// 1. BACKGROUND ( STATIC)
						Capsule()
							.fill(Color.white.opacity(0.2))
						
						Capsule()
							.fill(Color.white.opacity(0.2))
							.padding(8)
						// 2. CALL-TO-ACTION (STATIC )
						Text("Get Started")
							.font(.system(.title3, design: .rounded))
							.fontWeight(.bold)
							.foregroundColor(.white)
							.offset(x: 20)
						// 3. CAPSULE (DYNAMIC WIDTH)
						HStack {
							Capsule()
								.fill(Color("ColorPurple"))
								.frame(width: 80)
							
							Spacer()
						}
						// 4. CIRCLE (DRAGGABLE)
						
						HStack {
							 ZStack {
								Circle()
									.fill(Color("ColorPurple"))
								Circle()
									.fill(.black.opacity(0.15))
									.padding(8)
								Image(systemName: "chevron.right.2")
									.font(.system(size: 24, weight: .bold))
							}
							.foregroundColor(.white)
							.frame(width: 80, height: 80, alignment: .center)
							.onTapGesture {
								isOnboardingViewActive = false
							}
							
							Spacer()
						}//: HSTACK
					} // : FOOTER
					.frame(height: 80, alignment: .center)
					.padding()
				}// : VStack
			}//: ZStack
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
