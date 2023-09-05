//
//  attributedExtension.swift
//  collectionViewbyCode
//
//  Created by Seohyun Kim on 2023/09/05.
//

import UIKit

extension UIColor {
	static var cornflowerBlue: UIColor {
		return UIColor(displayP3Red: 100.0 / 255.0, green: 149.0 / 255.0, blue: 237.0 / 255.0, alpha: 1.0)
	}
	
	static var brightPink: UIColor {
		return UIColor(displayP3Red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 74.0 / 255.0, alpha: 1.0)
	}
	
	static var bubbleBlue: UIColor {
		return UIColor(displayP3Red: 113.0 / 255.0, green: 182.0 / 255.0, blue: 238.0 / 255.0, alpha: 1.0)
	}
	
	static var brightOrange: UIColor {
		return UIColor(displayP3Red: 255.0 / 255.0, green: 232.0 / 255.0, blue: 179.0 / 255.0, alpha: 1.0)
	}
	
	static var melon: UIColor {
		return UIColor(displayP3Red: 236.0 / 255.0, green: 247.0 / 255.0, blue: 204.0 / 255.0, alpha: 1.0)
	}
}

extension UIView {
	func setGradient(color1: UIColor, color2: UIColor) {
		let gradient: CAGradientLayer = CAGradientLayer()
		gradient.colors = [color1.cgColor, color2.cgColor]
		gradient.startPoint = CGPoint(x: 0.5, y: 1.0)
		gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
		gradient.frame = bounds
		layer.addSublayer(gradient)
	}
}
