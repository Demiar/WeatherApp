//
//  Weather.swift
//  WeatherApp
//
//  Created by Алексей on 25.06.2021.
//

import Foundation

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Temperature: Codable {
    let temp: Double
    let feels_like: Double
    let temp_max: Double
    let temp_min: Double
}

struct WeatherData: Codable {
    let id: Int?
    let name: String?
    let message: String?
    let weather: [Weather]?
    let main: Temperature?
}
