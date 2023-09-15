//
//  CustomCirlcleView.swift
//  Hike
//
//  Created by Seohyun Kim on 2023/09/16.
//

import SwiftUI

struct CustomCirlcleView: View {
	
	@State private var isAnimateGradient: Bool = false
	
    var body: some View {
		 ZStack {
			 Circle()
				 .fill(
					 LinearGradient(
						 colors: [
							.customIndigoMedium,
							.customSalmonLight
						 ],
						 startPoint: isAnimateGradient ? .topLeading : .bottomLeading,
						 endPoint: isAnimateGradient ? .bottomTrailing : .topTrailing
					 )
				 )
				 .onAppear {
					 withAnimation(.linear(duration: 3.0).repeatForever(autoreverses:true)) {
						 isAnimateGradient.toggle()
					 }
				 }
			 MotionAnimationView()
		 } //: ZSTACK
		 .frame(width: 256,height: 256)
		 
    }
}

struct CustomCirlcleView_Previews: PreviewProvider {
    static var previews: some View {
        CustomCirlcleView()
    }
}
