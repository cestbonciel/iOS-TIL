//
//  OnboardingView.swift
//  Restart
//
//  Created by Seohyun Kim on 2023/09/21.
//

import SwiftUI

struct OnboardingView: View {
	// MARK: - PROPERTY
	
	@AppStorage("onboarding") var isOnboardingViewActive: Bool = true
	@State private var buttonWidth: Double = UIScreen.main.bounds.width - 80
	@State private var buttonOffset: CGFloat = 0
	@State private var isAnimating: Bool = false
	@State private var imageOffset: CGSize = .zero
	@State private var indicatorOpacity: Double = 1.0
	@State private var textTitle: String = "Go Forward."
	
	let hapticFeedback = UINotificationFeedbackGenerator()
	
	// MARK: - Body
    var body: some View {
			ZStack {
				Color("ColorGreen")
					.ignoresSafeArea(.all, edges: .all)
				
				VStack {
					// MARK: - HEADER
					
					Spacer()
					
					VStack(spacing: 0) {
						Text(textTitle)
							.font(.system(size: 60))
							.fontWeight(.heavy)
							.foregroundColor(.white)
							.transition(.opacity)
							.id(textTitle)
						Text("""
	 Every day growing day by day.
	 """)
						.font(.title3)
						.fontWeight(.light)
						.foregroundColor(.white)
						.multilineTextAlignment(.center)
						.padding(.horizontal, 10)
					}// : HEADER
					.opacity(isAnimating ? 1 : 0)
					.offset(y: isAnimating ? 0 : -40)
					.animation(.easeOut(duration: 1), value: isAnimating)
					
					// MARK: - CENTER
					
					ZStack {
						CircleGroupView(shapeColor: .white, shapeOpacity: 0.2)
							.offset(x: imageOffset.width * -1)
							.blur(radius: abs(imageOffset.width / 5))
							.animation(.easeOut(duration: 1), value: imageOffset)
						//  This image has copyright 2020 © Seohyun Kim all right reserved.
						Image("IMG_8624")
							.resizable()
							.scaledToFit()
							.frame(width: 200, height: 200)
							.opacity(isAnimating ? 1 : 0)
							.animation(.easeOut(duration: 0.5), value: isAnimating)
							.offset(x: imageOffset.width * 1.2, y: 0)
							.rotationEffect(.degrees(Double(imageOffset.width / 20)))
							.gesture(
								DragGesture()
									.onChanged({ gesture in
										if abs(imageOffset.width) <= 150 {
											imageOffset = gesture.translation
											
											withAnimation(.linear(duration: 0.25)) {
												indicatorOpacity = 0
												textTitle = "Grow."
											}
										}
									})
									.onEnded({ _ in
										imageOffset = .zero
										
										withAnimation(.linear(duration: 0.25)) {
											indicatorOpacity = 1
											textTitle = "Go Forward."
										}
									})
							)//: GESTURE
							.animation(.easeOut(duration: 1), value: imageOffset)
					}//: CENTER
					.overlay(
						Image(systemName: "arrow.left.and.right.circle")
							.font(.system(size: 44, weight: .ultraLight))
							.foregroundColor(.white)
							.offset(y: 20)
							.opacity(isAnimating ? 1 : 0)
							.animation(.easeOut(duration: 1).delay(2), value: isAnimating)
							.opacity(indicatorOpacity)
						, alignment: .bottom
					)
					
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
								.frame(width: buttonOffset + 80)
							
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
							.offset(x: buttonOffset)
							.gesture(
								DragGesture()
									.onChanged { gesture in
										if gesture.translation.width > 0 && buttonOffset <= buttonWidth - 80 {
											buttonOffset = gesture.translation.width
										}
									}
									.onEnded { _ in
										withAnimation(Animation.easeOut(duration: 0.8)) {
											if buttonOffset > buttonWidth / 2 {
												hapticFeedback.notificationOccurred(.success)
												playSound(sound: "chimeup", type: "mp3")
												buttonOffset = buttonWidth - 80
												isOnboardingViewActive = false
											} else {
												hapticFeedback.notificationOccurred(.warning)
												buttonOffset = 0
											}
										}
									}
							)//: GESTURE
							
							Spacer()
						}//: HSTACK
					} // : FOOTER
					.frame(width: buttonWidth, height: 80, alignment: .center)
					.padding()
					.opacity(isAnimating ? 1 : 0)
					.offset(y: isAnimating ? 0 : 40)
					.animation(.easeInOut(duration: 1), value: isAnimating)
				}// : VStack
			}//: ZStack
			.onAppear {
				isAnimating = true
			}
			.preferredColorScheme(.dark)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
