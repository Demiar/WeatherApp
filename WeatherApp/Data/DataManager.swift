//
//  DataManager.swift
//  WeatherApp
//
//  Created by Алексей on 25.06.2021.
//

import Foundation
import Alamofire

class DataManager {

    static let shared = DataManager()
    let units = "metric"
    let lang = "ru"
    let defaultCity = ["Москва", "Лондон", "Омск"]
    
    private let url = "https://api.openweathermap.org/data/2.5/weather?"
    private let apiKey = "d4ef3717f7e55926d379e7a205329917"
    
    var getUrl: String {
        "\(url)appid=\(apiKey)&units=\(units)&lang=\(lang)"
    }
    
    func getWeather(city: String, _ completion: @escaping (WeatherData) -> Void) {
        AF.request("\(self.getUrl)&q=\(city)".encodeUrl).responseDecodable(of: WeatherData.self) { response in
            switch response.result {
            case .success:
                print(response.result)
                guard let weatherData = response.value else { return }
                completion(weatherData)
            case let .failure(error): print(error)
            }
        }
    }
}

