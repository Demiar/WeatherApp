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
    private let openWeatherMap = OpenWeatherMap(url: "https://api.openweathermap.org/data/2.5/weather?",
                                        units: "metric",
                                        lang: "ru",
                                        apiKey: "d4ef3717f7e55926d379e7a205329917"
    )
    let userDefaults = UserDefaults.standard
    let arrayKey = "citys"
    //var defaultCity: Array<String> = []
    var dataArray: [Dictionary<String, WeatherData>] = []
    var weatherDataArray: [WeatherData] = []
    var cities: [String] = ["Москва", "Лондон"]
    
    var getUrl: String {
        "\(openWeatherMap.url)appid=\(openWeatherMap.apiKey)&units=\(openWeatherMap.units)&lang=\(openWeatherMap.lang)"
    }
    
    init() {
        if userDefaults.array(forKey: arrayKey) == nil {
            userDefaults.set(["Москва", "Лондон"], forKey: arrayKey)
        }
        if let cities = UserDefaults.standard.array(forKey: arrayKey) as? [String] {
            self.cities = cities
        }
        
        for city in cities {
            getWeather(city: city, { weatherData in
                self.weatherDataArray.append(weatherData)
            })
//            getWeather(city: city, { [self] weatherData in
//                dataArray.append([city: weatherData])
//            })
        }
        
    }
    
    func getWeather(city: String, _ completion: @escaping (WeatherData) -> Void) {
        AF.request("\(self.getUrl)&q=\(city)".encodeUrl).responseDecodable(of: WeatherData.self) { response in
            if let notFound = response.response?.statusCode {
                if notFound == 404 {
                    return
                }
            }
            switch response.result {
            case .success:
                guard let weatherData = response.value else { return }
                completion(weatherData)
            case let .failure(error): print(error)
            }
        }
    }
    
    func saveCity(city: String) {
        cities.append(city)
        userDefaults.set(cities, forKey: arrayKey)
    }
    
    func deleteCity(city index: Int) {
        var currentIndex = 0
        weatherDataArray.remove(at: index)
        for city in cities {
            if city == weatherDataArray[index].name {
                cities.remove(at: currentIndex)
            }
            currentIndex += 1
        }
        userDefaults.set(cities, forKey: arrayKey)
    }
    
    
    func getIcon(icon: String) -> String{
        switch icon {
        case "Rain":
            return "rain"
        case "Snow":
            return "snow"
        case "Clouds":
            return "cloud"
        case "Wind":
            return "wind"
        case "Haze":
            return "cloud"
        default:
            return "sun"
        }
    }
    
}

