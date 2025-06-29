//
//  ContentView.swift
//  ConcurrencyDemo
//
//  Created by Nat Kim on 6/29/25.
//

import SwiftUI

struct ContentView: View {
	@StateObject private var testModel = TestResultModel()
	
	var body: some View {
		NavigationView {
			VStack(spacing: 20) {
				// 헤더
				HeaderSection()
				
				// 상태 표시
				if testModel.isRunning {
					StatusSection(testModel: testModel)
				}
				
				// 컨트롤 버튼들
				ControlSection(testModel: testModel)
				
				// 결과 표시
				if testModel.showResults && !testModel.logs.isEmpty {
					ResultsSection(logs: testModel.logs)
				}
				
				Spacer()
				
				// 푸터
				FooterSection()
			}
			.padding()
			.navigationBarHidden(true)
		}
	}
}

// MARK: - 헤더 섹션
struct HeaderSection: View {
	var body: some View {
		VStack {
			Image(systemName: "timer")
				.imageScale(.large)
				.foregroundStyle(.tint)
				.font(.system(size: 40))
			
			Text("Swift Concurrency Demo")
				.font(.title)
				.fontWeight(.bold)
			
			Text("Actor를 사용한 동시성 테스트")
				.font(.title3)
				.foregroundColor(.secondary)
				
			Text("🎯 Actor • TaskGroup • async/await • MainActor")
				.font(.caption)
				.foregroundColor(.secondary)
				.padding(.top, 4)
		}
		.padding()
	}
}

// MARK: - 상태 섹션
struct StatusSection: View {
	@ObservedObject var testModel: TestResultModel
	
	var body: some View {
		VStack {
			ProgressView(value: testModel.progressPercentage, total: 100)
				.progressViewStyle(LinearProgressViewStyle(tint: .blue))
				.frame(height: 8)
				.scaleEffect(x: 1, y: 2)
			
			Text("동시 작업 실행 중...")
				.font(.headline)
				.padding(.top)
			
			Text("완료된 작업: \(testModel.completedTaskCount)/\(testModel.totalTaskCount)")
				.font(.subheadline)
				.foregroundColor(.secondary)
				
			Text("진행률: \(Int(testModel.progressPercentage))%")
				.font(.caption)
				.foregroundColor(.secondary)
		}
		.padding()
		.background(Color(.systemGray6))
		.cornerRadius(12)
	}
}

// MARK: - 컨트롤 섹션
struct ControlSection: View {
	@ObservedObject var testModel: TestResultModel
	
	var body: some View {
		VStack(spacing: 15) {
			// 메인 버튼
			Button(action: testModel.startTest) {
				HStack {
					Image(systemName: "play.fill")
					Text("동시성 테스트 시작")
				}
				.font(.headline)
				.foregroundColor(.white)
				.frame(maxWidth: .infinity)
				.padding()
				.background(testModel.isRunning ? Color.gray : Color.blue)
				.cornerRadius(10)
			}
			.disabled(testModel.isRunning)
			
			// 서브 버튼들
			if !testModel.logs.isEmpty {
				HStack(spacing: 10) {
					Button(action: { testModel.showResults.toggle() }) {
						HStack {
							Image(systemName: testModel.showResults ? "eye.slash" : "eye")
							Text(testModel.showResults ? "결과 숨기기" : "결과 보기")
						}
						.font(.subheadline)
						.foregroundColor(.blue)
					}
					
					Button(action: testModel.clearResults) {
						HStack {
							Image(systemName: "trash")
							Text("결과 초기화")
						}
						.font(.subheadline)
						.foregroundColor(.red)
					}
				}
			}
		}
	}
}

// MARK: - 결과 섹션
struct ResultsSection: View {
	let logs: [String]
	
	var body: some View {
		ScrollView {
			LazyVStack(alignment: .leading, spacing: 8) {
				ForEach(logs, id: \.self) { log in
					Text(log)
						.font(.system(.caption, design: .monospaced))
						.padding(.horizontal, 12)
						.padding(.vertical, 4)
						.background(Color(.systemGray6))
						.cornerRadius(6)
				}
			}
			.padding()
		}
		.frame(maxHeight: 300)
		.background(Color(.systemBackground))
		.overlay(
			RoundedRectangle(cornerRadius: 8)
				.stroke(Color(.systemGray4), lineWidth: 1)
		)
	}
}

// MARK: - 푸터 섹션
struct FooterSection: View {
	var body: some View {
		VStack(spacing: 8) {
			Text("5개의 작업이 동시에 실행되며, Actor가 안전하게 상태를 관리합니다.")
				.font(.footnote)
				.foregroundColor(.secondary)
				.multilineTextAlignment(.center)
			
			Text("각 작업은 1-3초의 랜덤 시간이 소요됩니다.")
				.font(.caption2)
				.foregroundColor(.secondary)
		}
		.padding(.horizontal)
	}
}

#Preview {
	ContentView()
}
