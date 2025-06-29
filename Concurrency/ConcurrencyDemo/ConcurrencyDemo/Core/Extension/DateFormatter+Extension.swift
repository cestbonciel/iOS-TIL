//
//  DateFormatter+Extension.swift
//  ConcurrencyDemo
//
//  Created by Nat Kim on 6/29/25.
//

import Foundation

// MARK: - DateFormatter Extensions
extension DateFormatter {
	/// 시간 포맷터 (HH:mm:ss.SSS)
	static let timeFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "HH:mm:ss.SSS"
		return formatter
	}()
	
	/// 간단한 시간 포맷터 (HH:mm:ss)
	static let simpleTimeFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "HH:mm:ss"
		return formatter
	}()
}

// MARK: - String Extensions
extension String {
	/// 로그 메시지에 타임스탬프 추가
	func withTimestamp() -> String {
		let timestamp = DateFormatter.timeFormatter.string(from: Date())
		return "[\(timestamp)] \(self)"
	}
}

// MARK: - Dictionary Extensions
extension Dictionary where Key == Int, Value == Date {
	/// 태스크 완료 순서로 정렬된 배열 반환
	func sortedByTaskId() -> [(taskId: Int, date: Date)] {
		return self.sorted { $0.key < $1.key }.map { (taskId: $0.key, date: $0.value) }
	}
	
	/// 완료 시간 순서로 정렬된 배열 반환
	func sortedByCompletionTime() -> [(taskId: Int, date: Date)] {
		return self.sorted { $0.value < $1.value }.map { (taskId: $0.key, date: $0.value) }
	}
}
