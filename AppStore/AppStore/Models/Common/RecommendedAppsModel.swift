//
//  RecommendedAppsModel.swift
//  AppStore
//
//  Created by Nat Kim on 7/24/25.
//

import UIKit

// MARK: - Recommended Apps Model
struct RecommendedAppsModel {
	let id: String
	let headerCategory: String?  // 추가
	let headerTitle: String
	let apps: [AppDisplayInfo]
	
	static let sampleData: RecommendedAppsModel = {
		let apps = [
			AppDisplayInfo(
				appIcon: nil,
				category: nil,
				appName: "지그재그 - ZIGZAG",
				description: "제가 알아서 살게요",
				buttonType: .get,
				hasInAppPurchase: false,
				showInAppPurchaseInfo: false,
				backgroundColor: .systemPink
			),
			AppDisplayInfo(
				appIcon: nil,
				category: nil,
				appName: "밴드-모임이 쉬워진다!",
				description: "소모임, 챌린지, 스터디, 취미 모임",
				buttonType: .open,
				hasInAppPurchase: false,
				showInAppPurchaseInfo: false,
				backgroundColor: .systemGreen
			),
			AppDisplayInfo(
				appIcon: nil,
				category: nil,
				appName: "YouTube Music",
				description: "오직 나만을 위한 음악의 세계",
				buttonType: .open,
				hasInAppPurchase: false,
				showInAppPurchaseInfo: false,
				backgroundColor: .systemRed
			),
			AppDisplayInfo(
				appIcon: nil,
				category: nil,
				appName: "YouTube",
				description: "동영상과 음악을 즐기고 공유 하세요",
				buttonType: .open,
				hasInAppPurchase: false,
				showInAppPurchaseInfo: false,
				backgroundColor: .systemRed
			),
			AppDisplayInfo(
				appIcon: nil,
				category: nil,
				appName: "카카오톡",
				description: "모든 연결의 시작",
				buttonType: .update,
				hasInAppPurchase: false,
				showInAppPurchaseInfo: false,
				backgroundColor: .systemYellow
			)
		]
		
		return RecommendedAppsModel(
			id: "recommended-sample",
			headerCategory: "추천",
			headerTitle: "모두에게 사랑받는 앱",
			apps: apps
		)
	}()
	
	static let essentialAppsData: RecommendedAppsModel = {
		let apps = [
			AppDisplayInfo(
				appIcon: nil,
				category: nil,
				appName: "Trace: 할일∙일정∙루틴 관리 - AI 리마인더",
				description: "AI로 오늘 할일부터 일정까...",
				buttonType: .get,
				hasInAppPurchase: true,
				showInAppPurchaseInfo: true,
				backgroundColor: .systemBlue
			),
			AppDisplayInfo(
				appIcon: nil,
				category: nil,
				appName: "말해보카: 영단어, 문법, 리스닝, 스피킹, 영어 공부",
				description: "쉽게 할 수 있어야 쉽게 느니까",
				buttonType: .get,
				hasInAppPurchase: true,
				showInAppPurchaseInfo: true,
				backgroundColor: .systemOrange
			),
			AppDisplayInfo(
				appIcon: nil,
				category: nil,
				appName: "스픽 (Speak) - 영어회화, 스피킹, 발음",
				description: "영어학원이 싫어하는 영어어플",
				buttonType: .get,
				hasInAppPurchase: true,
				showInAppPurchaseInfo: true,
				backgroundColor: .systemGreen
			),
			AppDisplayInfo(
				appIcon: nil,
				category: nil,
				appName: "무디 Moodee : 지금의 감정에 필요한 것은?",
				description: "지금 내 감정에 꼭 필요한 퀘··",
				buttonType: .get,
				hasInAppPurchase: true,
				showInAppPurchaseInfo: true,
				backgroundColor: .systemPurple
			),
			AppDisplayInfo(
				appIcon: nil,
				category: nil,
				appName: "Planfit 플랜핏- 운동 루틴 추천과 헬스 홈트 다이어트 기록",
				description: "헬스 홈트 운동 추천 피트니..",
				buttonType: .get,
				hasInAppPurchase: true,
				showInAppPurchaseInfo: true,
				backgroundColor: .systemTeal
			)
		]
		
		return RecommendedAppsModel(
			id: "essential-apps",
			headerCategory: "필수 앱",
			headerTitle: "AI 앱으로 학기 준비 끝!",
			apps: apps
		)
	}()
}
