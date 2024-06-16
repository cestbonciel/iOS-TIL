//
//  WeatherManager.swift
//  Clima
//
//  Created by Seohyun Kim on 2023/10/28.
//

import Foundation

struct WeatherManager {
	let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=1fbd73b6bffd9493e25b910ab08c7aca&units=metric"
	
	func fetchWeather(cityName: String) {
		let urlString = "\(weatherURL)&q=\(cityName)"
		print(urlString)
		performRequest(urlString: urlString)
	}
	
	func performRequest(urlString: String) {
		// 1. Create a URL
		if let url = URL(string: urlString) {
			// 2. Create a URLSession
			let session = URLSession(configuration: .default)
			// 3. Give the session a task
			let task  = session.dataTask(with: url, completionHandler: handle(data: response: error: ))
			// 4. Start the task
			task.resume()
		}
	}
	
	func handle(data: Data?, response: URLResponse?, error: Error?) {
		if error != nil {
			print(error!)
			return
		}
		
		if let safeData = data {
			let dataString = String(data: safeData, encoding: .utf8)
			print(dataString)
		}
	}
}
