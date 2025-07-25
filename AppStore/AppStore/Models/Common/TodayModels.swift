//
//  TodayModels.swift
//  AppStore
//
//  Created by Nat Kim on 7/25/25.
//

import UIKit

// MARK: - Section Types
enum TodaySection: Int, CaseIterable {
	case appIntroduce = 0    // 앵그리버드 추가
	case temu = 1
	case recommended = 2
	case chatGPT = 3
	case roblox = 4
	
	var headerTitle: String? {
		switch self {
		case .appIntroduce:
			return nil
		case .temu, .recommended:
			return nil
		case .chatGPT:
			return "AI로 작업을 더 똑똑하게"
		case .roblox:
			return "온 가족과 함께"
		}
	}
	
	var headerSubtitle: String? {
		switch self {
		case .appIntroduce:
			return nil
		case .chatGPT:
			return "유용한 도구"
		case .roblox:
			return "집에서도 밖에서도 좋은 시간을 보내세요."
		case .temu, .recommended:
			return nil
		}
	}
}

// MARK: - Item Types
enum TodayItem: Hashable {
	case featuredApp(FeaturedAppModel)
	case temu(TemuStyleModel)
	case recommendedApps(RecommendedAppsModel)
	
	func hash(into hasher: inout Hasher) {
		switch self {
		case .featuredApp(let app):
			hasher.combine("featuredApp")
			hasher.combine(app.id)
		case .temu(let temu):
			hasher.combine("temu")
			hasher.combine(temu.id)
		case .recommendedApps(let recommended):
			hasher.combine("recommendedApps")
			hasher.combine(recommended.id)
		}
	}
	
	static func == (lhs: TodayItem, rhs: TodayItem) -> Bool {
		switch (lhs, rhs) {
		case (.featuredApp(let lhsApp), .featuredApp(let rhsApp)):
			return lhsApp.id == rhsApp.id
		case (.temu(let lhsTemu), .temu(let rhsTemu)):
			return lhsTemu.id == rhsTemu.id
		case (.recommendedApps(let lhsRecommended), .recommendedApps(let rhsRecommended)):
			return lhsRecommended.id == rhsRecommended.id
		default:
			return false
		}
	}
}

// MARK: - Featured App Model (ChatGPT, Roblox 등 큰 카드용)
struct FeaturedAppModel {
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
	
	func toAppIntroduce() -> AppIntroduce {
		return AppIntroduce(
			id: id,
			category: category,
			title: title,
			subtitle: subtitle,
			description: description,
			appIconName: appIconName,
			buttonType: buttonType,
			hasInAppPurchase: hasInAppPurchase,
			showInAppPurchaseInfo: showInAppPurchaseInfo,
			gradientColors: gradientColors
		)
	}
}

// MARK: - Sample Data
extension FeaturedAppModel {
	static let chatGPTSample = FeaturedAppModel(
		id: "chatgpt-1",
		category: "OpenAI의 공식 앱",
		title: "ChatGPT",
		subtitle: "강력한 관리자의 등장",
		description: "이렇게 하세요\n강력한 관리자의 등장",
		appIconName: "gpt",
		buttonType: .open,
		hasInAppPurchase: false,
		showInAppPurchaseInfo: false,
		gradientColors: [
			UIColor(red: 0.7, green: 0.3, blue: 0.9, alpha: 1.0),
			UIColor(red: 0.9, green: 0.5, blue: 0.2, alpha: 1.0),
			UIColor(red: 0.4, green: 0.8, blue: 0.9, alpha: 1.0)
		]
	)
	
	static let robloxSample = FeaturedAppModel(
		id: "roblox-1",
		category: "수천만 가지 가상 체험 공간",
		title: "Roblox",
		subtitle: "App Store의 강력 추천 게임을 살펴보세요.",
		description: "게임 핵심 정리\nRoblox",
		appIconName: "roblox",
		buttonType: .get,
		hasInAppPurchase: true,
		showInAppPurchaseInfo: true,
		gradientColors: [
			UIColor(red: 0.5, green: 0.6, blue: 0.7, alpha: 1.0),
			UIColor(red: 0.4, green: 0.5, blue: 0.6, alpha: 1.0)
		]
	)
}



