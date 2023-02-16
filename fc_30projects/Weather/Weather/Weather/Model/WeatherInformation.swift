//
//  WeatherInfomation.swift
//  Weather
//
//  Created by a0000 on 2022/12/05.
//

import Foundation

struct WeatherInformation: Codable {
	let weather: [Weather]
	let temp: Temp
	let name: String
	
	enum CodingKeys: String, CodingKey {
		case weather
		case temp = "main"
		case name
	}
}

struct Weather: Codable {
	let id: Int
	let main: String
	let description: String
	let icon: String
}

struct Temp: Codable {
	let temp: Double
	let feelsLike: Double
	let minTemp: Double
	let maxTemp: Double
//CodingKeys: json 에서 key name 이 다른 것을 스위프트 네이밍 컨벤션과 안맞을 경우 맵핑시켜주는 것
	enum CodingKeys: String, CodingKey {
		case temp
		case feelsLike = "feels_like"
		case minTemp = "temp_min"
		case maxTemp = "temp_max"
	}
}
// Codable
/*
 encodable 과 decodeble 준수
 encodable: 외부타입에서 디코딩
 decodable: 자신을 외부타입에서 디코딩할 수 있는 타입
 */

