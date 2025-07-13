import SwiftUI
import UIKit
import UserNotifications
import WidgetKit

@main
struct CoffeePushWidgetApp: App {
	@UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
	@StateObject private var pushManager = PushNotificationManager()
	
	var body: some Scene {
		WindowGroup {
			ContentView()
				.environmentObject(pushManager)
				.onAppear {
					// AppDelegate에 PushManager 주입
					appDelegate.pushManager = pushManager
				}
		}
	}
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
	var pushManager: PushNotificationManager?
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		print("🚀 App launched with CoffeePushWidget")
		
		// UNUserNotificationCenter delegate는 PushManager가 처리하지만
		// AppDelegate도 백업으로 설정 (시스템 호환성)
		UNUserNotificationCenter.current().delegate = self
		
		// 권한 요청은 이제 PushManager에서 처리
		// (앱 시작 시 자동 요청 대신 사용자 액션으로 변경 예정)
		
		return true
	}
	
	// 푸시 토큰 받기 → PushManager로 위임
	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		print("📱 AppDelegate received device token, delegating to PushManager")
		pushManager?.setDeviceToken(deviceToken)
	}
	
	// 푸시 토큰 등록 실패 → PushManager로 위임
	func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
		print("📱 AppDelegate received token error, delegating to PushManager")
		pushManager?.setDeviceTokenError(error)
	}
	
	// 앱이 포그라운드에 있을 때 푸시 알림 받기
	func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		print("Received push notification in foreground")
		
		// 위젯 업데이트
		WidgetCenter.shared.reloadAllTimelines()
		
		// 알림 표시 (선택사항)
		completionHandler([.banner, .sound])
	}
	
	// 백그라운드에서 푸시 알림 받기 → PushManager로 위임
	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
		print("📥 AppDelegate received background notification, delegating to PushManager")
		print("Payload: \(userInfo)")
		
		// 위젯 업데이트
		WidgetCenter.shared.reloadAllTimelines()
		
		// PushManager에게 처리 위임
		pushManager?.handleBackgroundNotification(userInfo)
		
		completionHandler(.newData)
	}
	
	// sendTokenToServer 로직은 PushNotificationManager로 이동됨
}
