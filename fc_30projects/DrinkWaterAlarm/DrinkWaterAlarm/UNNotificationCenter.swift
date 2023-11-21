//
//  UNNotificationCenter.swift
//  DrinkWaterAlarm
//
//  Created by a0000 on 2022/12/10.
//

import Foundation
import UserNotifications

extension UNUserNotificationCenter {
	func addNotificationRequest(by alert: Alert) {
		let content = UNMutableNotificationContent()
		content.title = "침대에 누울 시간이에요 🛌"
		content.body = "세계보건기구(WHO)가 권장하는 일반 성인의 개운한 수면시간은 7-9시간입니다."
		content.sound = .default
		content.badge = 1
		
		let component = Calendar.current.dateComponents([.hour, .minute], from: alert.date)
		let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: alert.isOn)
		let request = UNNotificationRequest(identifier: alert.id, content: content, trigger: trigger)
		
		self.add(request, withCompletionHandler: nil)
	}
}
