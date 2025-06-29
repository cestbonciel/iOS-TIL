//
//  NetworkManager.swift
//  CoffeePushWidget
//
//  Created by Nat Kim on 6/23/25.
//

import Foundation
import Combine
import Network

class NetworkManager: ObservableObject {
	@Published var isConnected = false
	
	private let monitor = NWPathMonitor()
	private let queue = DispatchQueue(label: "NetworkMonitor")
	private let serverURL = "http://localhost:3000"
	
	func startMonitoring() {
		monitor.pathUpdateHandler = { [weak self] path in
			DispatchQueue.main.async {
				self?.isConnected = path.status == .satisfied
			}
		}
		monitor.start(queue: queue)
	}
	
	func syncToServer(entry: CoffeeRecord) {
		guard isConnected else { return }
		
		guard let url = URL(string: "\(serverURL)/sync") else { return }
		
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		
		do {
			let jsonData = try JSONEncoder().encode(entry)
			request.httpBody = jsonData
			
			URLSession.shared.dataTask(with: request) { data, response, error in
				if let error = error {
					print("Sync error: \(error)")
				} else {
					print("Successfully synced to server")
				}
			}.resume()
		} catch {
			print("Encoding error: \(error)")
		}
	}
	
	func fetchFromServer(completion: @escaping ([CoffeeRecord]) -> Void) {
		guard isConnected else {
			completion([])
			return
		}
		
		guard let url = URL(string: "\(serverURL)/entries") else {
			completion([])
			return
		}
		
		URLSession.shared.dataTask(with: url) { data, response, error in
			guard let data = data,
				  let entries = try? JSONDecoder().decode([CoffeeRecord].self, from: data) else {
				completion([])
				return
			}
			
			DispatchQueue.main.async {
				completion(entries)
			}
		}.resume()
	}
}
