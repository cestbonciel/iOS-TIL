//
//  AppDisplayInfo.swift
//  AppStore
//
//  Created by Nat Kim on 7/24/25.
//

import UIKit

// MARK: - 공통 버튼 타입 
enum AppActionButtonType {
	case get
	case update
	case open
	case custom(String)
	
	var title: String {
		switch self {
		case .get: return "받기"
		case .update: return "업데이트"
		case .open: return "열기"
		case .custom(let title): return title
		}
	}
}

// MARK: - 앱 정보 모델
struct AppDisplayInfo {
	let appIcon: UIImage?
	let category: String?           // 서브타이틀 (옵셔널)
	let appName: String            // 메인 타이틀 (필수)
	let description: String?       // 설명 (옵셔널)
	let buttonType: AppActionButtonType
	let hasInAppPurchase: Bool
	let showInAppPurchaseInfo: Bool
	let backgroundColor: UIColor?
	
	var textColor: UIColor {
		guard let bgColor = backgroundColor else { return .label }
		return bgColor.contrastingTextColor
		
	}
}

extension UIColor {
	var contrastingTextColor: UIColor {
		return brightness > 0.5 ? .black : .white
	}
	
	var brightness: CGFloat {
		var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
		getRed(&red, green: &green, blue: &blue, alpha: &alpha)
		
		return (red * 299 + green * 587 + blue * 114) / 1000
	}
	
	var saturation: CGFloat {
		var hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0, alpha: CGFloat = 0
		getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
		return saturation
	}
	
	func lighter(by percentage: CGFloat) -> UIColor {
		var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
		getRed(&red, green: &green, blue: &blue, alpha: &alpha)
		
		return UIColor(
			red: min(red + percentage, 1.0),
			green: min(green + percentage, 1.0),
			blue: min(blue + percentage, 1.0),
			alpha: alpha
		)
	}
}
