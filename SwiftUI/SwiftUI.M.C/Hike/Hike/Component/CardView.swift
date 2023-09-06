//
//  CardView.swift
//  Hike
//
//  Created by Seohyun Kim on 2023/09/06.
//

import SwiftUI

struct CardView: View {
	var body: some View {
		// MARK: - CARD
		
		ZStack {
			CustomBackgroundView()
			
			ZStack {
				Circle()
					.fill(
						LinearGradient(
							colors: [
								Color("ColorIndigoMedium"),
								Color("ColorSalmonLight")
							],
							startPoint: .topLeading,
							endPoint: .bottomTrailing
						)
					)
					.frame(width: 256,height: 256)
				
				Image("image-1")
					.resizable()
					.scaledToFit()
			}
		} //: CARD
		.frame(width: 320, height: 570)
	}
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView()
    }
}
