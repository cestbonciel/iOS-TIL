//
//  Gradient.swift
//  Hike
//
//  Created by Seohyun Kim on 2023/09/07.
//

import Foundation
import SwiftUI

struct GradientButton: ButtonStyle {
	func makeBody(configuration: Configuration) -> some View {
		configuration
			.label
			.padding(.vertical)
			.padding(.horizontal, 30)
			.background(
				LinearGradient(
					colors: [
						.customGrayLight,
						.customGrayMedium],
					startPoint: .top,
					endPoint: .bottom)
			)
			.cornerRadius(40)
	}
}

