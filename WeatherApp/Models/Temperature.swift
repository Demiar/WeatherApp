//
//  Temperature.swift
//  WeatherApp
//
//  Created by Алексей on 04.07.2021.
//

import Foundation

struct Temperature: Codable {
    let temp: Double
    let feels_like: Double
    let temp_max: Double
    let temp_min: Double
}
