//
//  TestResultModel.swift
//  ConcurrencyDemo
//
//  Created by Nat Kim on 6/29/25.
//

import Foundation

/// 테스트 결과를 관리하는 ObservableObject
@MainActor
class TestResultModel: ObservableObject {
	@Published var isRunning = false
	@Published var completedTaskCount = 0
	@Published var totalTaskCount = 5
	@Published var logs: [String] = []
	@Published var showResults = false
	@Published var testResults: TestResult?
	
	/// 테스트 시작
	func startTest() {
		guard !isRunning else { return }
		
		isRunning = true
		completedTaskCount = 0
		logs.removeAll()
		showResults = false
		testResults = nil
		
		addLog("🚀 테스트 시작")
		addLog("📊 초기 상태: 저장된 타임스탬프 수 = 0")
		
		Task {
			await AsyncUtilities.runConcurrencyTest(
				taskCount: totalTaskCount,
				onProgress: { [weak self] completed in
					self?.updateProgress(completed)
				},
				onComplete: { [weak self] stamps, duration in
					self?.completeTest(stamps: stamps, duration: duration)
				}
			)
		}
	}
	
	/// 진행률 업데이트
	private func updateProgress(_ completed: Int) {
		completedTaskCount = completed
		addLog("✅ 완료된 작업: \(completed)/\(totalTaskCount)")
	}
	
	/// 테스트 완료 처리
	private func completeTest(stamps: [Int: Date], duration: TimeInterval) {
		let result = TestResult(
			completedTasks: stamps.count,
			totalDuration: duration,
			taskResults: stamps.sortedByTaskId()
		)
		
		testResults = result
		
		addLog("\n📊 최종 결과:")
		addLog("총 완료된 작업: \(result.completedTasks)")
		addLog("총 소요 시간: \(String(format: "%.1f", result.totalDuration))초")
		addLog("\n📝 작업별 완료 시간:")
		
		for taskResult in result.taskResults {
			addLog("Task \(taskResult.taskId): \(DateFormatter.timeFormatter.string(from: taskResult.date))")
		}
		
		addLog("\n✨ 테스트 완료!")
		
		isRunning = false
		showResults = true
	}
	
	/// 로그 추가
	func addLog(_ message: String) {
		logs.append(message.withTimestamp())
	}
	
	/// 결과 초기화
	func clearResults() {
		logs.removeAll()
		completedTaskCount = 0
		showResults = false
		testResults = nil
	}
	
	/// 진행률 계산
	var progressPercentage: Double {
		guard totalTaskCount > 0 else { return 0 }
		return Double(completedTaskCount) / Double(totalTaskCount)
	}
}


struct TestResult {
	let completedTasks: Int
	let totalDuration: TimeInterval
	let taskResults: [(taskId: Int, date: Date)]
	
	/// 평균 작업 시간
	var averageTaskDuration: TimeInterval {
		guard completedTasks > 0 else { return 0 }
		return totalDuration / Double(completedTasks)
	}
	
	/// 가장 빠른 작업
	var fastestTask: (taskId: Int, date: Date)? {
		return taskResults.min { $0.date < $1.date }
	}
	
	/// 가장 느린 작업
	var slowestTask: (taskId: Int, date: Date)? {
		return taskResults.max { $0.date < $1.date }
	}
}
