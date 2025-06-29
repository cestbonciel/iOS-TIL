//
//  AsyncUtilities.swift
//  ConcurrencyDemo
//
//  Created by Nat Kim on 6/29/25.
//

import Foundation

/// 비동기 작업 관련 유틸리티 함수들
enum AsyncUtilities {
	
	/// 시간이 오래 걸리는 비동기 작업을 시뮬레이션
	/// - Parameter taskId: 태스크 식별 ID
	/// - Returns: 작업 완료 시간
	static func takesTooLong(taskId: Int) async -> Date {
		print("⏳ Task \(taskId) 시작...")
		
		// 1-3초 랜덤 지연 (실제 비동기 처리)
		let sleepTime = UInt64.random(in: 1_000_000_000...3_000_000_000)
		try? await Task.sleep(nanoseconds: sleepTime)
		
		let date = Date()
		print("Task \(taskId) 완료: \(DateFormatter.timeFormatter.string(from: date))")
		return date
	}
	
	/// 동시성 테스트 실행
	/// - Parameters:
	///   - taskCount: 실행할 태스크 수
	///   - onProgress: 진행률 콜백 (완료된 태스크 수)
	///   - onComplete: 완료 콜백 (결과 딕셔너리, 총 소요시간)
	static func runConcurrencyTest(
		taskCount: Int = 5,
		onProgress: @escaping @MainActor (Int) -> Void,
		onComplete: @escaping @MainActor ([Int: Date], TimeInterval) -> Void
	) async {
		let startTime = Date()
		let store = TimeStore()
		
		
		// Actor 상태 초기화
		await store.clearStamps()
		
		// TaskGroup을 사용한 동시 실행
		await withTaskGroup(of: (Int, Date).self) { group in
			for i in 1...taskCount {
				group.addTask {
					let date = await takesTooLong(taskId: i)
					await store.addStamp(task: i, date: date)
					return (i, date)
				}
			}
			
			var completedCount = 0
			
			for await _ in group { // 순차적으로 안전하게 카운팅
				completedCount += 1
				
				// 이 순간의 값을 즉시 복사 - 동시성 안전성을 위한 복사임!!
				let currentCount = completedCount
				
				await MainActor.run {
					onProgress(currentCount)
				}
			}
		}
		
		// 최종 결과 수집
		let finalStamps = await store.getAllStamps()
		let endTime = Date()
		let duration = endTime.timeIntervalSince(startTime)
		
		// 완료 콜백 실행 (메인 액터에서)
		await MainActor.run {
			onComplete(finalStamps, duration)
		}
	}
}
