//
//  AppIntroduce.swift
//  AppStore
//
//  Created by Nat Kim on 7/23/25.
//
import UIKit

// MARK: - AppIntroduce Model
struct AppIntroduce {
	let id: String
	let category: String
	let title: String
	let subtitle: String
	let description: String?
	let appIconName: String
	let buttonType: AppActionButtonType  
	let hasInAppPurchase: Bool
	let showInAppPurchaseInfo: Bool
	let gradientColors: [UIColor]
	
	func toAppDisplayInfo() -> AppDisplayInfo {
		return AppDisplayInfo(
			appIcon: UIImage(named: appIconName),
			category: category,
			appName: title,
			description: subtitle,
			buttonType: buttonType,
			hasInAppPurchase: hasInAppPurchase,
			showInAppPurchaseInfo: showInAppPurchaseInfo,
			backgroundColor: nil
		)
	}
}

// MARK: - Sample Data
extension AppIntroduce {
	static let sampleData: [AppIntroduce] = [
		AppIntroduce(
			id: "1",
			category: "Apple Arcade",
			title: "Angry Birds Bounce",
			subtitle: "무리를 모으고 튕기세요!",
			description: "지금 APPLE ARCADE에서 만나요\n틀을 깨는 과감한 도전!",
			appIconName: "appIcon0",
			buttonType: .get,
			hasInAppPurchase: false,
			showInAppPurchaseInfo: false,
			gradientColors: [
				UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 1.0),
				UIColor(red: 0.1, green: 0.6, blue: 0.3, alpha: 1.0)
			]
		)
	]
}
