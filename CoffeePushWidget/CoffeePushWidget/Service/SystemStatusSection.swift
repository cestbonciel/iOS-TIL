//
//  SystemStatusSection.swift
//  CoffeePushWidget
//
//  Created by Nat Kim on 7/14/25.
//

import SwiftUI

struct SystemStatusSection: View {
	let pushManager: PushNotificationManager
	
	var body: some View {
		VStack(spacing: 12) {
			HStack {
				Image(systemName: "gear")
					.foregroundColor(.gray)
				Text("시스템 상태")
					.font(.title3)
					.fontWeight(.medium)
				Spacer()
			}
			
			VStack(spacing: 10) {
				StatusRow(
					icon: "bell.fill",
					title: "푸시 알림",
					status: pushManager.notificationPermissionStatus.description,
					isHealthy: pushManager.notificationPermissionStatus == .authorized,
					action: {
						if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
							UIApplication.shared.open(settingsUrl)
						}
					}
				)
				
				StatusRow(
					icon: "key.fill",
					title: "Device Token",
					status: pushManager.deviceToken != nil ? "등록됨" : "등록 중...",
					isHealthy: pushManager.deviceToken != nil,
					action: nil
				)
				
				StatusRow(
					icon: "rectangle.3.offgrid.fill",
					title: "위젯 동기화",
					status: "활성",
					isHealthy: true,
					action: nil
				)
			}
		}
		.padding(.vertical, 8)
	}
}

