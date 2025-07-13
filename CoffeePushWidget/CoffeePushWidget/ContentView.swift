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
	@StateObject private var networkManager = NetworkManager()
	@EnvironmentObject private var pushManager: PushNotificationManager
	@State private var showingAddCoffee = false
	@State private var showingPushSettings = false
	@State private var newCoffeeName = ""
	@State private var newCoffeeCaffeine = "125"
	
	var body: some View {
		NavigationView {
			VStack(spacing: 20) {
				// 오늘의 총 카페인
				VStack(spacing: 8) {
					Text("오늘의 총 카페인")
						.font(.headline)
						.foregroundColor(.secondary)
					
					Text("\(dataManager.todayTotalCaffeine)mg")
						.font(.system(size: 48, weight: .bold, design: .rounded))
						.foregroundColor(.primary)
					
					// 권장량 대비 표시
					let percentage = min(Double(dataManager.todayTotalCaffeine) / 400.0, 1.0)
					ProgressView(value: percentage)
						.tint(percentage > 0.8 ? .red : percentage > 0.6 ? .orange : .green)
						.scaleEffect(y: 2)
					
					Text("권장량: 400mg/일")
						.font(.caption)
						.foregroundColor(.secondary)
				}
				.padding()
				.background(Color(.systemGray6))
				.cornerRadius(12)
				
				// 최근 기록
				VStack(alignment: .leading, spacing: 12) {
					Text("오늘의 기록")
						.font(.headline)
					
					if dataManager.todayEntries.isEmpty {
						Text("아직 기록이 없습니다")
							.font(.body)
							.foregroundColor(.secondary)
							.frame(maxWidth: .infinity, alignment: .center)
							.padding()
					} else {
						ForEach(dataManager.todayEntries) { entry in
							HStack {
								VStack(alignment: .leading) {
									Text(entry.name)
										.font(.body)
										.fontWeight(.medium)
									Text(entry.timestamp, style: .time)
										.font(.caption)
										.foregroundColor(.secondary)
								}
								
								Spacer()
								
								Text("\(entry.caffeine)mg")
									.font(.body)
									.fontWeight(.semibold)
									.foregroundColor(.blue)
							}
							.padding(.vertical, 4)
						}
					}
				}
				.frame(maxWidth: .infinity, alignment: .leading)
				
				Spacer()
				
				// 스마트 알림 버튼
				// 스마트 알림 버튼
				VStack(spacing: 12) {
					// 🔧 디버그: 토큰 상태 확인
					Button {
						pushManager.checkTokenStatus()
					} label: {
						HStack {
							Image(systemName: "info.circle")
							Text("토큰 상태 확인")
						}
						.frame(maxWidth: .infinity)
						.padding()
						.background(Color.gray)
						.foregroundColor(.white)
						.cornerRadius(10)
					}
					
					// 🔧 디버그: 토큰 강제 새로고침
					Button {
						Task {
							await pushManager.forceRefreshDeviceToken()
						}
					} label: {
						HStack {
							Image(systemName: "arrow.clockwise")
							Text("토큰 새로고침")
						}
						.frame(maxWidth: .infinity)
						.padding()
						.background(Color.red)
						.foregroundColor(.white)
						.cornerRadius(10)
					}
					
					Button {
						Task {
							// 📊 디버그: 현재 상태 출력
							print("=== DEBUG INFO ===")
							print("📱 Device Token: \(pushManager.deviceToken ?? "nil")")
							print("🔔 Permission: \(pushManager.notificationPermissionStatus)")
							print("☕ Current Caffeine: \(dataManager.todayTotalCaffeine)")
							print("==================")
							
							await sendSmartCaffeineAlert()
						}
					} label: {
						HStack {
							Image(systemName: "brain.head.profile")
							Text("스마트 카페인 알림")
						}
						.frame(maxWidth: .infinity)
						.padding()
						.background(Color.blue)
						.foregroundColor(.white)
						.cornerRadius(10)
					}
					
					Button {
						Task {
							await sendSleepHealthAlert()
						}
					} label: {
						HStack {
							Image(systemName: "moon.stars")
							Text("수면 건강 알림")
						}
						.frame(maxWidth: .infinity)
						.padding()
						.background(Color.purple)
						.foregroundColor(.white)
						.cornerRadius(10)
					}
					.disabled(pushManager.deviceToken == nil)
				}
				/*
				VStack(spacing: 12) {
					Button {
						Task {
							await sendSmartCaffeineAlert()
						}
					} label: {
						HStack {
							Image(systemName: "brain.head.profile")
							Text("스마트 카페인 알림")
						}
						.frame(maxWidth: .infinity)
						.padding()
						.background(Color.blue)
						.foregroundColor(.white)
						.cornerRadius(10)
					}
					
					Button {
						Task {
							await sendSleepHealthAlert()
						}
					} label: {
						HStack {
							Image(systemName: "moon.stars")
							Text("수면 건강 알림")
						}
						.frame(maxWidth: .infinity)
						.padding()
						.background(Color.purple)
						.foregroundColor(.white)
						.cornerRadius(10)
					}
					.disabled(pushManager.deviceToken == nil)
				}
				*/
				// 푸시 알림 테스트 버튼
				/*	VStack(spacing: 12) {
				 Button {
				 Task {
				 await pushManager.scheduleTestNotification()
				 }
				 } label: {
				 HStack {
				 Image(systemName: "bell.badge")
				 Text("로컬 알림 테스트")
				 }
				 .frame(maxWidth: .infinity)
				 .padding()
				 .background(Color.orange)
				 .foregroundColor(.white)
				 .cornerRadius(10)
				 }
				 
				 Button {
				 Task {
				 await pushManager.sendPushNotification(
				 title: "☕ Supabase Push Test",
				 body: "Your coffee notification via Supabase!",
				 customData: ["source": "supabase", "coffeeType": "test"]
				 )
				 }
				 } label: {
				 HStack {
				 Image(systemName: "cloud.bolt")
				 Text("Supabase 푸시 테스트")
				 }
				 .frame(maxWidth: .infinity)
				 .padding()
				 .background(Color.purple)
				 .foregroundColor(.white)
				 .cornerRadius(10)
				 }
				 .disabled(pushManager.deviceToken == nil)
				 } */
				
				// 푸시 알림 & 위젯 상태
				VStack(spacing: 8) {
					HStack {
						Circle()
							.fill(pushManager.notificationPermissionStatus == .authorized ? .green : .orange)
							.frame(width: 8, height: 8)
						Text("푸시 알림: \(pushManager.notificationPermissionStatus.description)")
							.font(.caption)
							.foregroundColor(.secondary)
						
						Spacer()
						
						Button("권한 요청") {
							Task {
								await pushManager.requestNotificationPermission()
							}
						}
						.font(.caption)
						.buttonStyle(.borderedProminent)
						.controlSize(.mini)
					}
					
					HStack {
						Circle()
							.fill(pushManager.deviceToken != nil ? .green : .orange)
							.frame(width: 8, height: 8)
						Text("Device Token: \(pushManager.deviceToken != nil ? "등록됨" : "등록 중...")")
							.font(.caption)
							.foregroundColor(.secondary)
					}
					
					HStack {
						Circle()
							.fill(.green)
							.frame(width: 8, height: 8)
						Text("위젯 동기화 활성")
							.font(.caption)
							.foregroundColor(.secondary)
					}
				}
			}
			.padding()
			.navigationTitle("☕️ Coffee Tracker")
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					Button {
						showingAddCoffee = true
					} label: {
						Image(systemName: "plus.circle.fill")
							.font(.title2)
					}
				}
			}
			.sheet(isPresented: $showingAddCoffee) {
				NavigationView {
					VStack(spacing: 20) {
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
								quickAddButton("아메리카노", caffeine: 125)
								quickAddButton("에스프레소", caffeine: 75)
								quickAddButton("카페라떼", caffeine: 150)
								quickAddButton("카푸치노", caffeine: 120)
							}
						}
						
						Spacer()
						
						Button {
							addCoffee()
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
					.navigationBarTitleDisplayMode(.inline)
					.toolbar {
						ToolbarItem(placement: .navigationBarLeading) {
							Button("취소") {
								showingAddCoffee = false
								resetForm()
							}
						}
					}
				}
			}
		}
	}
	
	private func quickAddButton(_ name: String, caffeine: Int) -> some View {
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
			//await checkAndSendSmartNotification()
			await triggerSmartAutoNotification()
		}
		
		// 현재 사용 가능한 위젯 업데이트 방법
		WidgetCenter.shared.reloadAllTimelines()
		
		showingAddCoffee = false
		resetForm()
	}
	
	// 🧠 스마트 자동 알림 트리거
	private func triggerSmartAutoNotification() async {
		let currentCaffeine = dataManager.todayTotalCaffeine
		let hour = Calendar.current.component(.hour, from: Date())
		
		// 임계점 기반 자동 알림
		switch (currentCaffeine, hour) {
		
		// 🚨 즉시 경고가 필요한 상황
		case (400..., _):
			await pushManager.sendSmartCaffeineNotification(currentCaffeine: currentCaffeine)
			
		case (320..., 16...23), (320..., 0...6):
			await pushManager.sendSleepHealthNotification(currentCaffeine: currentCaffeine, hour: hour)
			
		// 📊 정보 제공 차원에서
		case (200..., 18...23):
			await pushManager.sendSleepHealthNotification(currentCaffeine: currentCaffeine, hour: hour)
			
		case (100..., 13...15):
			// 오후 적정량 도달 시 축하 메시지
			await pushManager.sendSmartCaffeineNotification(currentCaffeine: currentCaffeine)
			
		default:
			// 특별한 알림 없음 (조용히)
			print("📊 Current caffeine level: \(currentCaffeine)mg - No notification needed")
		}
	}

	
	private func resetForm() {
		newCoffeeName = ""
		newCoffeeCaffeine = "125"
	}
	
	private func sendSmartCaffeineAlert() async {
		let currentCaffeine = dataManager.todayTotalCaffeine
		await pushManager.sendSmartCaffeineNotification(currentCaffeine: currentCaffeine)
	}
	
	private func sendSleepHealthAlert() async {
		let currentCaffeine = dataManager.todayTotalCaffeine
		let hour = Calendar.current.component(.hour, from: Date())
		await pushManager.sendSleepHealthNotification(currentCaffeine: currentCaffeine, hour: hour)
	}
	
	private func checkAndSendSmartNotification() async {
		let currentCaffeine = dataManager.todayTotalCaffeine
		let hour = Calendar.current.component(.hour, from: Date())
		
		if currentCaffeine >= 400 {
			await pushManager.sendSmartCaffeineNotification(currentCaffeine: currentCaffeine)
		} else if currentCaffeine >= 320 && hour >= 16 {
			await pushManager.sendSleepHealthNotification(currentCaffeine: currentCaffeine, hour: hour)
		}
	}
}

#Preview {
	ContentView()
}
