//
//  TemuStyleModel.swift
//  AppStore
//
//  Created by Nat Kim on 7/25/25.
//

import Foundation
import UIKit

// MARK: - Temu Style Model
struct TemuStyleModel {
	let id: String
	let centerAppIconName: String  // 가운데 큰 앱 아이콘
	let appTitle: String          // 앱 제목
	let hasAdBadge: Bool          // 광고 뱃지 여부
	let description: String       // 설명 텍스트
	let buttonType: AppActionButtonType
}

// MARK: - Sample Data
extension TemuStyleModel {
	static let sampleData = TemuStyleModel(
		id: "temu-sample",
		centerAppIconName: "temu_icon", // 76x76 아이콘
		appTitle: "Temu: 억만장자처럼 쇼핑하기",
		hasAdBadge: true,
		description: "역대급 할인 혜택을 Temu에서 만나보세요",
		buttonType: .get
	)
}
