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
	var anonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imdtdnp6bW9za2xheWVsdGhwdW1jIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTA3MDc4NDksImV4cCI6MjA2NjI4Mzg0OX0.iuvq-1gaXNmEQU08QbC28QKmzWkbZST5pK4tiS3dHqw"
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
	
	// MARK: - Device Token Management
	
	@MainActor
	private func registerForRemoteNotifications() async {
		guard UIApplication.shared.isRegisteredForRemoteNotifications == false else {
			print("📱 Already registered for remote notifications")
			return
		}
		
		UIApplication.shared.registerForRemoteNotifications()
		print("📱 Registering for remote notifications...")
	}
	
	func setDeviceToken(_ tokenData: Data) {
		let token = tokenData.map { String(format: "%02.2hhx", $0) }.joined()
		
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
		switch currentCaffeine {
		case 400...:
			return SmartNotification(
				title: "일일 카페인 한도 초과",
				body: "권장량 400mg를 초과했어요! 건강을 위해 물을 드세요",
				customData: ["type": "caffeine_exceeded", "level": "critical"]
			)
		case 320..<400:
			return SmartNotification(
				title: "카페인 주의",
				body: "오늘 \(currentCaffeine)mg 섭취했어요. 권장량까지 \(400 - currentCaffeine)mg 남았습니다.",
				customData: ["type": "caffeine_warning", "level": "high"]
			)
		case 240..<320:
			return SmartNotification(
				title: "카페인 체크",
				body: "오늘 \(currentCaffeine)mg 섭취 중이에요. 적당한 수준을 유지하고 있어요!",
				customData: ["type": "caffeine_check", "level": "medium"]
			)
		case 120..<240:
			return SmartNotification(
				title: "커피 타임",
				body: "현재 \(currentCaffeine)mg 섭취했어요. 오후 집중력을 위해 커피 한 잔 어떠세요?",
				customData: ["type": "caffeine_suggestion", "level": "low"]
			)
		default:
			return SmartNotification(
				title: "좋은 아침!",
				body: "새로운 하루가 시작됐어요! 모닝 커피로 활기찬 하루를 시작해보세요",
				customData: ["type": "morning_boost", "level": "none"]
			)
		}
	}
	
	private func generateSleepHealthNotification(currentCaffeine: Int, hour: Int) -> SmartNotification {
		if hour >= 18 && currentCaffeine >= 200 {
			return SmartNotification(
				title: "수면 건강 알림",
				body: "저녁 시간이에요. 좋은 잠을 위해 카페인 대신 물이나 허브차는 어떠세요?",
				customData: ["type": "sleep_health", "time": "evening"]
			)
		} else if hour >= 14 && currentCaffeine >= 300 {
			return SmartNotification(
				title: "수면을 위한 제안",
				body: "이미 충분한 카페인을 섭취했어요. 밤에 잘 자기 위해 이제 물을 드세요!",
				customData: ["type": "sleep_suggestion", "time": "afternoon"]
			)
		} else if hour >= 22 || hour <= 6 {
			return SmartNotification(
				title: "늦은 시간입니다",
				body: "지금은 휴식 시간이에요. 카페인보다는 따뜻한 물이나 허브차를 추천해요.",
				customData: ["type": "sleep_time", "time": "night"]
			)
		} else {
			return SmartNotification(
				title: "수면 건강 체크",
				body: "현재 카페인 수준이 좋아요! 저녁까지 이 상태를 유지하시면 좋은 잠을 잘 수 있을 거예요.",
				customData: ["type": "sleep_ok", "time": "day"]
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
		let supabaseURL = "https://gmvzzmosklayelthpumc.supabase.co"
		let functionURL = "\(supabaseURL)/functions/v1/send-push"
		
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
