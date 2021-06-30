//
//  DataManager.swift
//  WeatherApp
//
//  Created by Алексей on 25.06.2021.
//

import Foundation

class DataManager {

    let units = "metric"
    let lang = "ru"
    let defaultCity = ["Москва", "Лондон", "Омск"]
    var weatherData: [WeatherData] = []
    
    private let url = "https://api.openweathermap.org/data/2.5/weather?"
    private let apiKey = "d4ef3717f7e55926d379e7a205329917"
    
    var getUrl: String {
        "\(url)appid=\(apiKey)&units=\(units)&lang=\(lang)"
    }
    
    private func getWeather(city: String){
        if let url = URL(string: ("\(self.getUrl)&q=\(city)").encodeUrl) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let weatherData = try decoder.decode(WeatherData.self, from: data)
                        DispatchQueue.main.async {
                            self.weatherData.append(weatherData)
                        }
                    } catch {
                        print(error)
                    }
                }
           }.resume()
        }
    }
}

