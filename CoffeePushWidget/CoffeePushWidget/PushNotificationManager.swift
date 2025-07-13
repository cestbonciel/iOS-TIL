//
//  PushNotificationManager.swift
//  CoffeePushWidget
//
//  Created by Nat Kim on 6/24/25.
//
import Foundation
import UserNotifications
import UIKit

@MainActor
final class PushNotificationManager: NSObject, ObservableObject {
	@Published var deviceToken: String?
	@Published var notificationPermissionStatus: UNAuthorizationStatus = .notDetermined
	@Published var lastNotification: [AnyHashable: Any]?
	
	// 스마트 알림 설정
	@Published var smartNotificationsEnabled: Bool = true
	@Published var sleepModeStartHour: Int = 22 // 오후 10시
	@Published var sleepModeEndHour: Int = 7   // 오전 7시
	
	// var anonKey = ""
	private var supabaseURL: String {
		return AppConfig.supabaseURL
	}
	
	private var anonKey: String {
		return AppConfig.supabaseAnonKey
	}
	
	
	override init() {
		super.init()
		UNUserNotificationCenter.current().delegate = self
		checkNotificationPermission()
		loadUserPreferences()
	}
	
	// MARK: - Permission Management
		
	func requestNotificationPermission() async -> Bool {
		do {
			let granted = try await UNUserNotificationCenter.current().requestAuthorization(
				options: [.alert, .sound, .badge]
			)
			
			await MainActor.run {
				self.notificationPermissionStatus = granted ? .authorized : .denied
			}
			
			if granted {
				await registerForRemoteNotifications()
			}
			
			return granted
		} catch {
			print("❌ Failed to request notification permission: \(error)")
			return false
		}
	}
	
	private func checkNotificationPermission() {
		UNUserNotificationCenter.current().getNotificationSettings { settings in
			DispatchQueue.main.async {
				self.notificationPermissionStatus = settings.authorizationStatus
			}
		}
	}
	
	func forceRefreshDeviceToken() async {
		print("🔄 Force refreshing device token...")
		
		await MainActor.run {
			// 1. 기존 등록 해제
			UIApplication.shared.unregisterForRemoteNotifications()
			print("📱 Unregistered for remote notifications")
			
			// 2. 잠시 대기 후 재등록
			DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
				UIApplication.shared.registerForRemoteNotifications()
				print("📱 Re-registering for remote notifications...")
			}
		}
	}
	
	// MARK: - Device Token Management
	
	@MainActor
	private func registerForRemoteNotifications() async {
//		guard UIApplication.shared.isRegisteredForRemoteNotifications == false else {
//			print("📱 Already registered for remote notifications")
//			return
//		}
//		
//		UIApplication.shared.registerForRemoteNotifications()
//		print("📱 Registering for remote notifications...")
		print("📱 Registering for remote notifications...")
		UIApplication.shared.registerForRemoteNotifications()
		
		// 등록 상태와 관계없이 항상 시도
		print("📱 Registration attempt completed")
	}
	
	func setDeviceToken(_ tokenData: Data) {
		let token = tokenData.map { String(format: "%02.2hhx", $0) }.joined()
		
		print("🎯 Raw token data length: \(tokenData.count)")
		print("🔑 Generated token length: \(token.count)")

		
		Task { @MainActor in
			self.deviceToken = token
			
			// 디버그 빌드에서만 출력
			#if DEBUG
			print("🔑 Device Token: \(token)")
			#endif
			
			await uploadDeviceTokenToSupabase(token)
		}
	}
	
	func setDeviceTokenError(_ error: Error) {
		print("❌ Failed to get device token: \(error)")
	}
	
	// 토큰 상태 확인 메서드 추가
	func checkTokenStatus() {
		print("=== TOKEN STATUS ===")
		print("📱 Device Token: \(deviceToken ?? "nil")")
		print("🔔 Permission: \(notificationPermissionStatus)")
		print("📋 Is Registered: \(UIApplication.shared.isRegisteredForRemoteNotifications)")
		print("==================")
	}
	
	// MARK: - Smart Notification Engine
	
	func sendSmartCaffeineNotification(currentCaffeine: Int) async {
		guard smartNotificationsEnabled && !isInSleepMode() else { return }
		
		let notification = generateCaffeineNotification(currentCaffeine: currentCaffeine)
		await sendPushNotification(
			title: notification.title,
			body: notification.body,
			customData: notification.customData
		)
	}
	
	func sendSleepHealthNotification(currentCaffeine: Int, hour: Int) async {
		guard smartNotificationsEnabled else { return }
		
		let notification = generateSleepHealthNotification(currentCaffeine: currentCaffeine, hour: hour)
		await sendPushNotification(
			title: notification.title,
			body: notification.body,
			customData: notification.customData
		)
	}
	
	private func generateCaffeineNotification(currentCaffeine: Int) -> SmartNotification {
		let hour = Calendar.current.component(.hour, from: Date())
		
		// 시간대별 + 카페인 수준별 로직
		switch (currentCaffeine, hour) {
			
			// 🚨 위험 수준 (400mg 이상) - 시간 관계없이 경고
		case (400..., _):
			return SmartNotification(
				title: "🚨 카페인 과다 섭취",
				body: "권장량 400mg를 초과했어요! 즉시 카페인 섭취를 중단하고 물을 드세요.",
				customData: ["type": "critical_warning", "level": "dangerous"]
			)
			
			// 🔥 경고 수준 (320-399mg)
		case (320..<400, 18...23), (320..<400, 0...6):
			return SmartNotification(
				title: "🌙 늦은 시간 카페인 경고",
				body: "이미 \(currentCaffeine)mg 섭취했고 늦은 시간이에요. 수면을 위해 더 이상 드시지 마세요.",
				customData: ["type": "evening_warning", "level": "high"]
			)
		case (320..<400, _):
			return SmartNotification(
				title: "⚠️ 카페인 주의",
				body: "오늘 \(currentCaffeine)mg 섭취했어요. 권장량까지 \(400 - currentCaffeine)mg 남았습니다.",
				customData: ["type": "moderate_warning", "level": "high"]
			)
			
			// 😴 저녁/밤 시간 (18시 이후)
		case (200..<320, 18...23), (200..<320, 0...6):
			return SmartNotification(
				title: "🌜 수면을 위한 제안",
				body: "저녁 시간이네요. 좋은 잠을 위해 카페인보다는 허브차나 물을 추천해요.",
				customData: ["type": "evening_suggestion", "level": "medium"]
			)
			
			// ☕ 적정 수준 (100-199mg)
		case (100..<200, 7...9):
			return SmartNotification(
				title: "🌅 좋은 아침!",
				body: "현재 \(currentCaffeine)mg 섭취 중이에요. 아침 집중력을 위해 커피 한 잔 더 어떠세요?",
				customData: ["type": "morning_boost", "level": "low"]
			)
		case (100..<200, 13...15):
			return SmartNotification(
				title: "☕ 오후 에너지 충전",
				body: "오후 나른함을 이길 시간! 현재 \(currentCaffeine)mg로 적당한 수준이에요.",
				customData: ["type": "afternoon_boost", "level": "low"]
			)
		case (100..<200, _):
			return SmartNotification(
				title: "✅ 적정 카페인 수준",
				body: "현재 \(currentCaffeine)mg로 좋은 수준이에요! 하루 종일 활기차게 보내세요.",
				customData: ["type": "optimal_level", "level": "low"]
			)
			
			// 🌅 아침 시간 + 카페인 없음/적음 (0-99mg)
		case (0..<100, 6...9):
			return SmartNotification(
				title: "🌅 모닝 커피 타임",
				body: "새로운 하루가 시작됐어요! 모닝 커피로 활기찬 하루를 시작해보세요.",
				customData: ["type": "morning_start", "level": "none"]
			)
			
			// 🌃 밤 시간 + 카페인 적음
		case (0..<100, 20...23), (0..<100, 0...6):
			return SmartNotification(
				title: "🌙 좋은 밤!",
				body: "오늘 카페인 섭취가 적어서 좋은 잠을 잘 수 있을 거예요. 편안한 밤 되세요.",
				customData: ["type": "good_night", "level": "none"]
			)
			
			// 🍃 기본 (점심 시간 등)
		default:
			return SmartNotification(
				title: "☕ 커피 브레이크",
				body: "현재 \(currentCaffeine)mg 섭취했어요. 필요하시면 적당한 커피 한 잔 어떠세요?",
				customData: ["type": "general_suggestion", "level": "none"]
			)
		}
	}
	
	private func generateSleepHealthNotification(currentCaffeine: Int, hour: Int) -> SmartNotification {
		// 🌙 실제 수면 건강 기반 로직
		switch (currentCaffeine, hour) {
			
			// 밤 시간 + 고카페인
		case (300..., 20...23), (300..., 0...6):
			return SmartNotification(
				title: "🚨 수면 위험 경고",
				body: "밤 시간에 \(currentCaffeine)mg는 매우 위험해요! 불면증 위험이 높습니다.",
				customData: ["type": "sleep_danger", "time": "night"]
			)
			
			// 저녁 시간 + 중간 카페인
		case (200..<300, 18...20):
			return SmartNotification(
				title: "🌅 수면 준비 시간",
				body: "저녁이에요. 좋은 잠을 위해 이제부터는 물이나 허브차를 드세요.",
				customData: ["type": "sleep_prep", "time": "evening"]
			)
			
			// 오후 늦은 시간 + 고카페인
		case (250..., 15...17):
			return SmartNotification(
				title: "😴 수면을 위한 주의",
				body: "오후 늦은 시간에 \(currentCaffeine)mg는 밤잠에 영향을 줄 수 있어요.",
				customData: ["type": "afternoon_warning", "time": "late_afternoon"]
			)
			
			// 적정 수준
		case (0..<200, _):
			return SmartNotification(
				title: "✅ 수면 건강 양호",
				body: "현재 카페인 수준(\(currentCaffeine)mg)이 좋아요! 좋은 잠을 잘 수 있을 거예요.",
				customData: ["type": "sleep_healthy", "time": "any"]
			)
			
		default:
			return SmartNotification(
				title: "🛌 수면 건강 체크",
				body: "현재 \(currentCaffeine)mg 섭취했어요. 저녁까지 적당히 조절하시면 좋겠어요.",
				customData: ["type": "sleep_moderate", "time": "day"]
			)
		}
	}
	
	// MARK: - Utility Functions
	
	private func isInSleepMode() -> Bool {
		let hour = Calendar.current.component(.hour, from: Date())
		
		if sleepModeStartHour > sleepModeEndHour {
			// 예: 22시 ~ 7시 (다음날)
			return hour >= sleepModeStartHour || hour <= sleepModeEndHour
		} else {
			// 예: 1시 ~ 6시 (같은 날)
			return hour >= sleepModeStartHour && hour <= sleepModeEndHour
		}
	}
	
	private func loadUserPreferences() {
		let userDefaults = UserDefaults.standard
		smartNotificationsEnabled = userDefaults.object(forKey: "smartNotificationsEnabled") as? Bool ?? true
		sleepModeStartHour = userDefaults.object(forKey: "sleepModeStartHour") as? Int ?? 22
		sleepModeEndHour = userDefaults.object(forKey: "sleepModeEndHour") as? Int ?? 7
	}
	
	func saveUserPreferences() {
		let userDefaults = UserDefaults.standard
		userDefaults.set(smartNotificationsEnabled, forKey: "smartNotificationsEnabled")
		userDefaults.set(sleepModeStartHour, forKey: "sleepModeStartHour")
		userDefaults.set(sleepModeEndHour, forKey: "sleepModeEndHour")
	}
	
	// MARK: - Supabase Integration
	
	private func uploadDeviceTokenToSupabase(_ token: String) async {
		print("📤 Uploading device token to Supabase...")
		await saveTokenToDatabase(token)
	}
	
	private func saveTokenToDatabase(_ token: String) async {
		print("💾 Would save token to Supabase database: \(token)")
		// 실제 데이터베이스 저장 로직은 나중에 구현
	}
	
	// Supabase Edge Function을 통한 푸시 알림 전송
	func sendPushNotification(title: String, body: String, customData: [String: Any] = [:]) async {
		guard let deviceToken = self.deviceToken else {
			print("❌ No device token available")
			return
		}
		
		print("📤 Sending smart push via Supabase Edge Function...")
		print("📝 Title: \(title)")
		print("📝 Body: \(body)")
		
		// Supabase Edge Function URL 구성
		let functionURL = "\(AppConfig.edgeFunctionURL)/functions/v1/send-push"
		
		guard let url = URL(string: functionURL) else {
			print("❌ Invalid Supabase function URL")
			return
		}
		
		// 요청 페이로드 구성
		let payload: [String: Any] = [
			"deviceToken": deviceToken,
			"title": title,
			"body": body,
			"badge": 1,
			"sound": "default",
			"customData": customData
		]
		
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		// TODO: 실제 Supabase Anon Key로 교체 필요
		request.setValue("Bearer \(anonKey)", forHTTPHeaderField: "Authorization")
		
		do {
			request.httpBody = try JSONSerialization.data(withJSONObject: payload)
			
			let (data, response) = try await URLSession.shared.data(for: request)
			
			if let httpResponse = response as? HTTPURLResponse {
				print("📱 Supabase Response Status: \(httpResponse.statusCode)")
				
				if httpResponse.statusCode == 200 {
					if let responseData = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
						print("✅ Push notification sent successfully: \(responseData)")
					}
				} else {
					if let errorData = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
						print("❌ Supabase Error: \(errorData)")
					}
				}
			}
			
		} catch {
			print("❌ Network error: \(error)")
		}
	}
	
	// 백그라운드 알림 처리
	func handleBackgroundNotification(_ userInfo: [AnyHashable: Any]) {
		Task { @MainActor in
			self.lastNotification = userInfo
			print("📱 Background notification processed by PushManager")
		}
	}
	
	// MARK: - Local Notification for Testing
	
	func scheduleTestNotification() async {
		let content = UNMutableNotificationContent()
		content.title = "Coffee Time!"
		content.body = "Your perfect espresso is ready"
		content.sound = .default
		content.badge = 1
		
		let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
		let request = UNNotificationRequest(
			identifier: "test-coffee-notification",
			content: content,
			trigger: trigger
		)
		
		do {
			try await UNUserNotificationCenter.current().add(request)
			print("📲 Local test notification scheduled")
		} catch {
			print("❌ Failed to schedule notification: \(error)")
		}
	}
}

// MARK: - UNUserNotificationCenterDelegate

extension PushNotificationManager: UNUserNotificationCenterDelegate {
	
	func userNotificationCenter(
		_ center: UNUserNotificationCenter,
		willPresent notification: UNNotification,
		withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
	) {
		print("📩 Received notification while app is active: \(notification.request.content.title)")
		completionHandler([.banner, .sound, .badge])
	}
	
	func userNotificationCenter(
		_ center: UNUserNotificationCenter,
		didReceive response: UNNotificationResponse,
		withCompletionHandler completionHandler: @escaping () -> Void
	) {
		let userInfo = response.notification.request.content.userInfo
		print("👆 User tapped notification: \(userInfo)")
		
		Task { @MainActor in
			self.lastNotification = userInfo
		}
		
		completionHandler()
	}
}

// MARK: - Helper Extensions

extension UNAuthorizationStatus {
	var description: String {
		switch self {
		case .notDetermined: return "Not Determined"
		case .denied: return "Denied"
		case .authorized: return "Authorized"
		case .provisional: return "Provisional"
		case .ephemeral: return "Ephemeral"
		@unknown default: return "Unknown"
		}
	}
}
