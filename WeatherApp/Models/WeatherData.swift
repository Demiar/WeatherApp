//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Алексей on 04.07.2021.
//

import Foundation

struct WeatherData: Codable {
    let id: Int?
    let name: String?
    let message: String?
    let weather: [Weather]?
    let main: Temperature?
}
