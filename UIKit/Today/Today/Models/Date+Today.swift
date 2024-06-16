//
//  Date+Today.swift
//  Today
//
//  Created by Seohyun Kim on 2023/08/30.
//

import Foundation

extension Date {
	var dayAndTimeText: String {
		let timeText = formatted(date: .omitted, time: .shortened)
		if Locale.current.calendar.isDateInToday(self) {
			let timeFormat = NSLocalizedString("Today at %@", comment: "Today at time format string.")
			return String(format: timeFormat, timeText)
		} else {
			let dateText = formatted(.dateTime.month(.abbreviated).day())
			let dateAndTimeFormat = NSLocalizedString("%@ at %@", comment: "Date and time format string")
			return String(format: dateAndTimeFormat, dateText, timeText)
		}
	}
	
	var dayText: String {
		// 현재 달력 날짜인 경우 정적문자열을 반환하는 dayText 라는 계산된 문자열 속성을 만듦.
		if Locale.current.calendar.isDateInToday(self) {
			return NSLocalizedString("Today", comment: "Today due date description")
		} else {
			return formatted(.dateTime.month().day().weekday(.wide))
		}
	}
}
