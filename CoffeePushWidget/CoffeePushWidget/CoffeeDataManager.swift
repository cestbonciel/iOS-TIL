//
//  CoffeeDataManager.swift
//  CoffeePushWidget
//
//  Created by Nat Kim on 6/23/25.
//

import Foundation
import Combine

class CoffeeDataManager: ObservableObject {
	@Published var entries: [CoffeeRecord] = []
	@Published var todayEntries: [CoffeeRecord] = []
	@Published var todayTotalCaffeine: Int = 0
	
	private let userDefaults: UserDefaults
	private let entriesKey = "coffeeEntries"
	
	   init() {
		   self.userDefaults = UserDefaults(suiteName: "group.com.seohyunKim.iOS.CoffeePushWidget") ?? UserDefaults.standard
		   loadEntries()
		   updateTodayData()
	   }
	   
	   func addEntry(_ entry: CoffeeRecord) {
		   entries.insert(entry, at: 0) // 최신 순으로 정렬
		   saveEntries()
		   updateTodayData()
	   }
	   
	   func deleteEntry(_ entry: CoffeeRecord) {
		   entries.removeAll { $0.id == entry.id }
		   saveEntries()
		   updateTodayData()
	   }
	   
	   private func loadEntries() {
		   guard let data = userDefaults.data(forKey: entriesKey),
				 let decodedEntries = try? JSONDecoder().decode([CoffeeRecord].self, from: data) else {
			   entries = []
			   return
		   }
		   entries = decodedEntries.sorted { $0.timestamp > $1.timestamp }
	   }
	   
	   private func saveEntries() {
		   guard let data = try? JSONEncoder().encode(entries) else { return }
		   userDefaults.set(data, forKey: entriesKey)
	   }
	   
	   private func updateTodayData() {
		   let today = Calendar.current.startOfDay(for: Date())
		   let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
		   
		   todayEntries = entries.filter { entry in
			   entry.timestamp >= today && entry.timestamp < tomorrow
		   }
		   
		   todayTotalCaffeine = todayEntries.reduce(0) { $0 + $1.caffeine }
	   }
	   
	   // 서버에서 데이터 동기화
	   func syncFromServer(_ serverEntries: [CoffeeRecord]) {
		   // 중복 제거하면서 병합
		   var allEntries = entries
		   for serverEntry in serverEntries {
			   if !allEntries.contains(where: { $0.id == serverEntry.id }) {
				   allEntries.append(serverEntry)
			   }
		   }
		   
		   entries = allEntries.sorted { $0.timestamp > $1.timestamp }
		   saveEntries()
		   updateTodayData()
	   }
	
}
