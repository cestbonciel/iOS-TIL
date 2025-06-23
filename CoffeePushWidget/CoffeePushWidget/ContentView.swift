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
	@State private var showingAddCoffee = false
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
				
				// 위젯 업데이트 상태
				HStack {
					Circle()
						.fill(.green)
						.frame(width: 8, height: 8)
					Text("위젯 동기화 활성")
						.font(.caption)
						.foregroundColor(.secondary)
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
		
		// 현재 사용 가능한 위젯 업데이트 방법
		WidgetCenter.shared.reloadAllTimelines()
		
		showingAddCoffee = false
		resetForm()
	}
	
	private func resetForm() {
		newCoffeeName = ""
		newCoffeeCaffeine = "125"
	}
}

#Preview {
	ContentView()
}
