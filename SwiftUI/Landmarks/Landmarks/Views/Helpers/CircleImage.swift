//
//  CircleImage.swift
//  LandmarksApp
//
//  Created by Seohyun Kim on 2023/07/25.
//

import SwiftUI

struct CircleImage: View {
	var image: Image
	
    var body: some View {
        image
			.clipShape(Circle())
			.overlay {
				Circle().stroke(.white, lineWidth: 4)
			}
			.shadow(radius: 7)
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
		CircleImage(image: Image("turtlerock"))
    }
}
