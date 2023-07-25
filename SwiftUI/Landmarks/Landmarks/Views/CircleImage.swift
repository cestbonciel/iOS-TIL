//
//  CircleImage.swift
//  LandmarksApp
//
//  Created by Seohyun Kim on 2023/07/25.
//

import SwiftUI

struct CircleImage: View {
    var body: some View {
        Image("turtlerock")
			.clipShape(Circle())
			.overlay {
				Circle().stroke(.white, lineWidth: 4)
			}
			.shadow(radius: 7)
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage()
    }
}
