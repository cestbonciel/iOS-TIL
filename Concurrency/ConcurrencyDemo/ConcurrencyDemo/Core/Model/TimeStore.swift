//
//  TimeStore.swift
//  ConcurrencyDemo
//
//  Created by Nat Kim on 6/29/25.
//
import Foundation
import SwiftUI

actor TimeStore {
	private var timeStamps: [Int: Date] = [:]

	func addStamp(task: Int, date: Date) {
		timeStamps[task] = date
		print("Task \(task) 저장 완료: \(DateFormatter.timeFormatter.string(from: date))")
	}
	
	/// 모든 타임스탬프 반환
	/// - Returns: 태스크 ID와 완료 시간의 딕셔너리
	func getAllStamps() -> [Int: Date] {
		return timeStamps
	}
	
	/// 저장된 타임스탬프 개수 반환
	/// - Returns: 타임스탬프 개수
	func getStampCount() -> Int {
		return timeStamps.count
	}
	
	/// 모든 타임스탬프 삭제
	func clearStamps() {
		timeStamps.removeAll()
		print("모든 타임스탬프 삭제됨")
	}
	
	/// 특정 태스크의 타임스탬프 조회
	/// - Parameter taskId: 태스크 ID
	/// - Returns: 해당 태스크의 완료 시간 (없으면 nil)
	func getStamp(for taskId: Int) -> Date? {
		return timeStamps[taskId]
	}
}
