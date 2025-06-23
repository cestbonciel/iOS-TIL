//
//  CoffeePushWidgetApp.swift
//  CoffeePushWidget
//
//  Created by Nat Kim on 6/23/25.
//

import SwiftUI
import UIKit
import UserNotifications
import WidgetKit

@main
struct CoffeePushWidgetApp: App {
	@UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
	
	var body: some Scene {
		WindowGroup {
			ContentView()
		}
	}
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		// Push Notification 권한 요청
		UNUserNotificationCenter.current().delegate = self
		UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
			if granted {
				print("Push notification permission granted")
				DispatchQueue.main.async {
					UIApplication.shared.registerForRemoteNotifications()
				}
			} else {
				print("Push notification permission denied")
			}
		}
		
		return true
	}
	
	// 푸시 토큰 받기
	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		let tokenString = deviceToken.map { String(format: "%02x", $0) }.joined()
		print("Device Token: \(tokenString)")
		
		// 서버로 토큰 전송
		sendTokenToServer(tokenString)
	}
	
	// 푸시 토큰 등록 실패
	func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
		print("Failed to register for remote notifications: \(error)")
	}
	
	// 앱이 포그라운드에 있을 때 푸시 알림 받기
	func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		print("Received push notification in foreground")
		
		// 위젯 업데이트
		WidgetCenter.shared.reloadAllTimelines()
		
		// 알림 표시 (선택사항)
		completionHandler([.banner, .sound])
	}
	
	// 백그라운드에서 푸시 알림 받기
	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
		print("Received background push notification")
		print("Payload: \(userInfo)")
		
		// 위젯 업데이트
		WidgetCenter.shared.reloadAllTimelines()
		
		completionHandler(.newData)
	}
	
	private func sendTokenToServer(_ token: String) {
		guard let url = URL(string: "http://localhost:3000/register-token") else {
			print("Invalid server URL")
			return
		}
		
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		
		let payload = ["token": token, "type": "general"]
		
		do {
			request.httpBody = try JSONSerialization.data(withJSONObject: payload)
			
			URLSession.shared.dataTask(with: request) { data, response, error in
				if let error = error {
					print("Token send error: \(error)")
				} else {
					print("Token sent to server successfully")
				}
			}.resume()
		} catch {
			print("Token encoding error: \(error)")
		}
	}
}
