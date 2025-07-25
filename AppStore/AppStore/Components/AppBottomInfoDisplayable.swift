//
//  AppBottomInfoDisplayable.swift
//  AppStore
//
//  Created by Nat Kim on 7/25/25.
//

import Foundation
import UIKit

enum ButtonStyle {
	case whiteTransparent
	case blackTransparent
	case custom(backgroundColor: UIColor, textColor: UIColor)
}

struct StyleConfiguration {
	let containerColor: UIColor?
	let buttonStyle: ButtonStyle?
	
	static let chatGPT = StyleConfiguration(
		containerColor: UIColor.black.withAlphaComponent(0.6),
		buttonStyle: .whiteTransparent
	)
	
	static let brightBackground = StyleConfiguration(
		containerColor: UIColor.white.withAlphaComponent(0.8),
		buttonStyle: .blackTransparent
	)
	
	static let automatic = StyleConfiguration(
		containerColor: nil,
		buttonStyle: nil
	)
}


protocol AppBottomInfoDisplayable {
	var bottomContainerView: UIView? { get }
	var downloadButton: UIButton? { get }
	
	func setupBottomStyle(containerColor: UIColor, buttonStyle: ButtonStyle)
}

extension AppBottomInfoDisplayable {
	func setupBottomStyle(containerColor: UIColor, buttonStyle: ButtonStyle) {
		bottomContainerView?.backgroundColor = containerColor
		guard let button = downloadButton else { return }
		
		switch buttonStyle {
		case .whiteTransparent:
			button.backgroundColor = UIColor.white.withAlphaComponent(0.3)
			button.setTitleColor(.white, for: .normal)
		case .blackTransparent:
			button.backgroundColor = UIColor.black.withAlphaComponent(0.2)
			button.setTitleColor(.white, for: .normal)
		case .custom(let bgColor, let textColor):
			button.backgroundColor = bgColor
			button.setTitleColor(textColor, for: .normal)
		}
	}
}
