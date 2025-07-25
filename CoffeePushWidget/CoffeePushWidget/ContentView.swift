//
//  ContentView.swift
//  CoffeePushWidget
//
//  Created by Nat Kim on 6/23/25.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
	@StateObject private var dataManager = CoffeeDataManager()
	//	@StateObject private var networkManager = NetworkManager()
	@EnvironmentObject private var pushManager: PushNotificationManager
	@State private var showingAddCoffee = false
	@State private var showingPushSettings = false
	@State private var newCoffeeName = ""
	@State private var newCoffeeCaffeine = "125"
	
	var body: some View {
		NavigationView {
			ScrollView {
				VStack(spacing: 24) {
					// 🎯 개선된 카페인 카드
					CaffeineStatusCard(totalCaffeine: dataManager.todayTotalCaffeine)
					
					// 📋 오늘의 기록 섹션
					TodayRecordsSection(entries: dataManager.todayEntries)
					
					// 🔔 스마트 알림 섹션
					SmartNotificationSection(
						pushManager: pushManager,
						dataManager: dataManager,
						onSmartAdvice: sendContextualAdvice,
						onDailySummary: sendDailySummary
					)
					
					// 📱 시스템 상태 섹션
					SystemStatusSection(pushManager: pushManager)
					
					// 🎯 하단 여백 (마지막 요소가 가려지지 않도록)
					Spacer(minLength: 20)
				}
				.padding(.horizontal, 16)
				.padding(.top, 8)
			}
			.navigationTitle("Coffee Tracker")
			.navigationBarTitleDisplayMode(.large)
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					Button {
						showingAddCoffee = true
					} label: {
						Image(systemName: "plus.circle.fill")
							.font(.title2)
							.foregroundColor(.blue)
					}
				}
			}
			.sheet(isPresented: $showingAddCoffee) {
				AddCoffeeSheet(
					showingAddCoffee: $showingAddCoffee,
					newCoffeeName: $newCoffeeName,
					newCoffeeCaffeine: $newCoffeeCaffeine,
					onAddCoffee: addCoffee,
					onResetForm: resetForm
				)
			}
		}
	}
	
	// MARK: - 커피 추가 로직
	
	private func addCoffee() {
		guard let caffeine = Int(newCoffeeCaffeine) else { return }
		
		let entry = CoffeeRecord(
			id: UUID(),
			name: newCoffeeName,
			caffeine: caffeine,
			timestamp: Date()
		)
		
		dataManager.addEntry(entry)
		
		Task {
			await triggerSmartAutoNotification()
		}
		
		WidgetCenter.shared.reloadAllTimelines()
		showingAddCoffee = false
		resetForm()
	}
	
	private func triggerSmartAutoNotification() async {
		let currentCaffeine = dataManager.todayTotalCaffeine
		let hour = Calendar.current.component(.hour, from: Date())
		
		switch (currentCaffeine, hour) {
		case (400..., _):
			await pushManager.sendSmartCaffeineNotification(currentCaffeine: currentCaffeine)
		case (320..., 16...23), (320..., 0...6):
			await pushManager.sendSleepHealthNotification(currentCaffeine: currentCaffeine, hour: hour)
		case (200..., 18...23):
			await pushManager.sendSleepHealthNotification(currentCaffeine: currentCaffeine, hour: hour)
		case (100..., 13...15):
			await pushManager.sendSmartCaffeineNotification(currentCaffeine: currentCaffeine)
		default:
			print("📊 Current caffeine level: \(currentCaffeine)mg - No notification needed")
		}
	}
	
	private func resetForm() {
		newCoffeeName = ""
		newCoffeeCaffeine = "125"
	}
	
	private func sendContextualAdvice() async {
		let currentCaffeine = dataManager.todayTotalCaffeine
		await pushManager.sendSmartCaffeineNotification(currentCaffeine: currentCaffeine)
	}
	
	private func sendDailySummary() async {
		let currentCaffeine = dataManager.todayTotalCaffeine
		let hour = Calendar.current.component(.hour, from: Date())
		await pushManager.sendSleepHealthNotification(currentCaffeine: currentCaffeine, hour: hour)
	}
}

// MARK: - 카페인 상태 카드

struct CaffeineStatusCard: View {
	let totalCaffeine: Int
	
	var body: some View {
		VStack(spacing: 16) {
			// 📊 제목과 수치
			VStack(spacing: 8) {
				Text("오늘의 총 카페인")
					.font(.title2)
					.fontWeight(.semibold)
					.foregroundColor(.secondary)
				
				Text("\(totalCaffeine)mg")
					.font(.system(size: 56, weight: .bold, design: .rounded))
					.foregroundColor(.primary)
					.minimumScaleFactor(0.8) // 🎯 긴 숫자 대응
			}
			
			// 📈 진행률 바
			VStack(spacing: 8) {
				let percentage = min(Double(totalCaffeine) / 400.0, 1.0)
				let progressColor = getProgressColor(percentage: percentage)
				
				ProgressView(value: percentage)
					.tint(progressColor)
					.scaleEffect(y: 3) // 🎯 더 두껍게
					.animation(.easeInOut(duration: 0.3), value: percentage)
				
				HStack {
					Text("권장량: 400mg/일")
						.font(.footnote)
						.foregroundColor(.secondary)
					
					Spacer()
					
					// 🎯 상태 표시
					Text(getStatusText(caffeine: totalCaffeine))
						.font(.footnote)
						.fontWeight(.medium)
						.foregroundColor(progressColor)
				}
			}
		}
		.padding(20)
		.background(
			RoundedRectangle(cornerRadius: 16)
				.fill(Color(.systemGray6))
				.shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
		)
	}
	
	private func getProgressColor(percentage: Double) -> Color {
		switch percentage {
		case 0..<0.25: return .blue
		case 0.25..<0.5: return .green
		case 0.5..<0.75: return .orange
		case 0.75..<1.0: return .red
		default: return .purple
		}
	}
	
	private func getStatusText(caffeine: Int) -> String {
		switch caffeine {
		case 0..<100: return "시작 단계"
		case 100..<200: return "좋은 수준"
		case 200..<300: return "적정 수준"
		case 300..<400: return "주의 필요"
		default: return "과다 섭취"
		}
	}
}

// MARK: - 오늘의 기록 섹션

struct TodayRecordsSection: View {
	let entries: [CoffeeRecord]
	
	var body: some View {
		VStack(alignment: .leading, spacing: 16) {
			// 📋 섹션 헤더
			HStack {
				Text("오늘의 기록")
					.font(.title2)
					.fontWeight(.semibold)
				
				Spacer()
				
				Text("\(entries.count)잔")
					.font(.caption)
					.padding(.horizontal, 8)
					.padding(.vertical, 4)
					.background(Color.blue.opacity(0.1))
					.foregroundColor(.blue)
					.cornerRadius(8)
			}
			
			// 📝 기록 목록
			if entries.isEmpty {
				EmptyRecordsView()
			} else {
				LazyVStack(spacing: 12) {
					ForEach(entries) { entry in
						CoffeeRecordRow(entry: entry)
					}
				}
			}
		}
		.frame(maxWidth: .infinity, alignment: .leading)
	}
}

struct EmptyRecordsView: View {
	var body: some View {
		VStack(spacing: 12) {
			Image(systemName: "cup.and.saucer")
				.font(.system(size: 40))
				.foregroundColor(.gray.opacity(0.6))
			
			Text("아직 기록이 없습니다")
				.font(.body)
				.foregroundColor(.secondary)
			
			Text("+ 버튼을 눌러 첫 커피를 기록해보세요")
				.font(.caption)
				.foregroundColor(.secondary)
		}
		.frame(maxWidth: .infinity)
		.padding(.vertical, 24)
	}
}

struct CoffeeRecordRow: View {
	let entry: CoffeeRecord
	
	var body: some View {
		HStack(spacing: 16) {
			// ☕ 커피 아이콘
			Circle()
				.fill(getCaffeineColor(entry.caffeine).opacity(0.2))
				.frame(width: 44, height: 44)
				.overlay(
					Image(systemName: "cup.and.saucer.fill")
						.foregroundColor(getCaffeineColor(entry.caffeine))
						.font(.system(size: 16))
				)
			
			// 📝 정보
			VStack(alignment: .leading, spacing: 4) {
				Text(entry.name)
					.font(.body)
					.fontWeight(.medium)
				
				Text(entry.timestamp, style: .time)
					.font(.caption)
					.foregroundColor(.secondary)
			}
			
			Spacer()
			
			// 💊 카페인량
			VStack(alignment: .trailing, spacing: 2) {
				Text("\(entry.caffeine)mg")
					.font(.body)
					.fontWeight(.semibold)
					.foregroundColor(getCaffeineColor(entry.caffeine))
				
				Text(getCaffeineLevel(entry.caffeine))
					.font(.caption2)
					.foregroundColor(.secondary)
			}
		}
		.padding(.vertical, 8)
	}
	
	private func getCaffeineColor(_ caffeine: Int) -> Color {
		switch caffeine {
		case 0..<75: return .green
		case 75..<150: return .blue
		case 150..<200: return .orange
		default: return .red
		}
	}
	
	private func getCaffeineLevel(_ caffeine: Int) -> String {
		switch caffeine {
		case 0..<75: return "약함"
		case 75..<150: return "보통"
		case 150..<200: return "강함"
		default: return "매우강함"
		}
	}
}

// MARK: - 스마트 알림 섹션

struct SmartNotificationSection: View {
	let pushManager: PushNotificationManager
	let dataManager: CoffeeDataManager
	let onSmartAdvice: () async -> Void
	let onDailySummary: () async -> Void
	
	var body: some View {
		VStack(spacing: 16) {
			// 📊 섹션 헤더
			HStack {
				Image(systemName: "brain.head.profile")
					.foregroundColor(.blue)
				Text("스마트 알림")
					.font(.title2)
					.fontWeight(.semibold)
				Spacer()
			}
			
			// 🔔 알림 버튼들
			VStack(spacing: 12) {
				SmartActionButton(
					icon: "lightbulb",
					title: "지금 상황에 맞는 조언",
					subtitle: "현재 \(dataManager.todayTotalCaffeine)mg 기준 맞춤 조언",
					color: .blue,
					action: onSmartAdvice
				)
				
				SmartActionButton(
					icon: "chart.bar.xaxis",
					title: "오늘의 카페인 분석",
					subtitle: "수면과 건강에 미치는 영향 확인",
					color: .green,
					action: onDailySummary
				)
				
				// 🔧 토큰 문제 시에만 표시
				if !pushManager.isTokenHealthy {
					SmartActionButton(
						icon: "arrow.clockwise",
						title: "알림 연결 복구",
						subtitle: "푸시 알림 연결에 문제가 있어요",
						color: .orange,
						action: {
							Task {
								await pushManager.refreshTokenIfNeeded()
							}
						}
					)
				}
				
#if DEBUG
				// 🔧 개발자 도구 (릴리즈에서는 숨김)
				DisclosureGroup {
					VStack(spacing: 8) {
						Button("토큰 상태 확인") {
							pushManager.checkTokenStatus()
						}
						.foregroundColor(.blue)
						
						Button("강제 토큰 새로고침") {
							Task {
								await pushManager.forceRefreshDeviceToken()
							}
						}
						.foregroundColor(.red)
					}
					.padding(.top, 8)
				} label: {
					Label("개발자 도구", systemImage: "wrench")
						.font(.caption)
						.foregroundColor(.secondary)
				}
#endif
			}
		}
	}
}

struct SmartActionButton: View {
	let icon: String
	let title: String
	let subtitle: String
	let color: Color
	let action: () async -> Void
	
	@State private var isLoading = false
	
	var body: some View {
		Button {
			Task {
				isLoading = true
				await action()
				isLoading = false
			}
		} label: {
			HStack(spacing: 16) {
				// 🎨 아이콘
				Circle()
					.fill(color.opacity(0.1))
					.frame(width: 44, height: 44)
					.overlay(
						Group {
							if isLoading {
								ProgressView()
									.scaleEffect(0.8)
							} else {
								Image(systemName: icon)
									.foregroundColor(color)
									.font(.system(size: 18))
							}
						}
					)
				
				// 📝 텍스트
				VStack(alignment: .leading, spacing: 4) {
					Text(title)
						.font(.body)
						.fontWeight(.medium)
						.foregroundColor(.primary)
					
					Text(subtitle)
						.font(.caption)
						.foregroundColor(.secondary)
						.lineLimit(2)
				}
				
				Spacer()
				
				// 🎯 적절한 액션 아이콘
				if isLoading {
					ProgressView()
						.scaleEffect(0.7)
				} else {
					// ✅ 더 적절한 아이콘들
					Image(systemName: getActionIcon(for: icon))
						.font(.caption)
						.foregroundColor(color)
						.opacity(0.7)
				}
			}
			.padding(.horizontal, 16)
			.padding(.vertical, 12)
			.background(
				RoundedRectangle(cornerRadius: 12)
					.fill(Color(.systemBackground))
					.overlay(
						RoundedRectangle(cornerRadius: 12)
							.stroke(color.opacity(0.2), lineWidth: 1)
					)
			)
		}
		.buttonStyle(.plain)
		.disabled(isLoading)
	}
	
	private func getActionIcon(for mainIcon: String) -> String {
		switch mainIcon {
		case "lightbulb":
			return "bubble.right"  // 조언/대화
		case "chart.bar.xaxis":
			return "doc.text.magnifyingglass"  // 분석/검토
		case "arrow.clockwise":
			return "wrench"  // 수리/복구
		default:
			return "play.fill"  // 기본 실행
		}
	}
}

// MARK: - 시스템 상태 섹션


struct StatusRow: View {
	let icon: String
	let title: String
	let status: String
	let isHealthy: Bool
	let action: (() -> Void)?
	
	var body: some View {
		HStack(spacing: 12) {
			// 🎨 상태 아이콘
			Circle()
				.fill(isHealthy ? Color.green.opacity(0.2) : Color.orange.opacity(0.2))
				.frame(width: 32, height: 32)
				.overlay(
					Image(systemName: icon)
						.font(.system(size: 14))
						.foregroundColor(isHealthy ? .green : .orange)
				)
			
			// 📝 정보
			VStack(alignment: .leading, spacing: 2) {
				Text(title)
					.font(.body)
					.fontWeight(.medium)
				
				Text(status)
					.font(.caption)
					.foregroundColor(.secondary)
			}
			
			Spacer()
			
			// 🔧 액션 버튼
			if let action = action, !isHealthy {
				Button("설정") {
					action()  // ✅ 직접 호출
				}
				.font(.caption)
				.buttonStyle(.borderedProminent)
				.controlSize(.mini)
			}
		}
		.padding(.horizontal, 4)
	}
}

// MARK: - 커피 추가 시트

struct AddCoffeeSheet: View {
	@Binding var showingAddCoffee: Bool
	@Binding var newCoffeeName: String
	@Binding var newCoffeeCaffeine: String
	let onAddCoffee: () -> Void
	let onResetForm: () -> Void
	
	var body: some View {
		NavigationView {
			ScrollView {
				VStack(spacing: 24) {
					Text("새 커피 기록")
						.font(.title2)
						.fontWeight(.bold)
					
					VStack(alignment: .leading, spacing: 8) {
						Text("커피 종류")
							.font(.headline)
						TextField("예: 아메리카노", text: $newCoffeeName)
							.textFieldStyle(RoundedBorderTextFieldStyle())
					}
					
					VStack(alignment: .leading, spacing: 8) {
						Text("카페인 함량 (mg)")
							.font(.headline)
						TextField("125", text: $newCoffeeCaffeine)
							.textFieldStyle(RoundedBorderTextFieldStyle())
							.keyboardType(.numberPad)
					}
					
					// 빠른 선택 버튼들
					VStack(alignment: .leading, spacing: 8) {
						Text("빠른 선택")
							.font(.headline)
						
						LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
							QuickAddButton("아메리카노", caffeine: 125, newCoffeeName: $newCoffeeName, newCoffeeCaffeine: $newCoffeeCaffeine)
							QuickAddButton("에스프레소", caffeine: 75, newCoffeeName: $newCoffeeName, newCoffeeCaffeine: $newCoffeeCaffeine)
							QuickAddButton("카페라떼", caffeine: 150, newCoffeeName: $newCoffeeName, newCoffeeCaffeine: $newCoffeeCaffeine)
							QuickAddButton("카푸치노", caffeine: 120, newCoffeeName: $newCoffeeName, newCoffeeCaffeine: $newCoffeeCaffeine)
						}
					}
					
					Spacer(minLength: 20)
					
					Button {
						onAddCoffee()
					} label: {
						Text("추가하기")
							.frame(maxWidth: .infinity)
							.padding()
							.background(Color.blue)
							.foregroundColor(.white)
							.cornerRadius(10)
					}
					.disabled(newCoffeeName.isEmpty || newCoffeeCaffeine.isEmpty)
				}
				.padding()
			}
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading) {
					Button("취소") {
						showingAddCoffee = false
						onResetForm()
					}
				}
			}
		}
	}
}

struct QuickAddButton: View {
	let name: String
	let caffeine: Int
	@Binding var newCoffeeName: String
	@Binding var newCoffeeCaffeine: String
	
	init(_ name: String, caffeine: Int, newCoffeeName: Binding<String>, newCoffeeCaffeine: Binding<String>) {
		self.name = name
		self.caffeine = caffeine
		self._newCoffeeName = newCoffeeName
		self._newCoffeeCaffeine = newCoffeeCaffeine
	}
	
	var body: some View {
		Button {
			newCoffeeName = name
			newCoffeeCaffeine = "\(caffeine)"
		} label: {
			VStack(spacing: 4) {
				Text(name)
					.font(.caption)
					.fontWeight(.medium)
				Text("\(caffeine)mg")
					.font(.caption2)
					.foregroundColor(.secondary)
			}
			.frame(maxWidth: .infinity)
			.padding(.vertical, 8)
			.background(Color(.systemGray5))
			.cornerRadius(8)
		}
		.buttonStyle(PlainButtonStyle())
	}
}

#Preview {
	ContentView()
}
