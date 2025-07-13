//
//  Config-Example.swift
//  CoffeePushWidget
//
//  Created by Nat Kim on 7/13/25.
//

import Foundation

struct AppConfigSample {
	// Supabase 설정
	static let supabaseURL = "https://YOUR_PROJECT_ID.supabase.co"
	static let supabaseAnonKey = "YOUR_ANON_KEY_HERE"
	
	// APNs 설정 (앱에서는 사용하지 않음, 참고용)
	static let apnsBundleId = "com.yourcompany.yourapp"
	
	// 기타 설정
	static let appGroupId = "group.com.yourcompany.yourapp"
	static let userDefaultsKey = "coffeeEntries"
}

extension AppConfigSample {
	static var edgeFunctionURL: String {
		return "\(supabaseURL)/functions/v1/send-push"
	}
}
