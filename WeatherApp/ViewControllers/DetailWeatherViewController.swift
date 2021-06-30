//
//  DetailWeatherViewController.swift
//  WeatherApp
//
//  Created by Алексей on 25.06.2021.
//

import UIKit

class DetailWeatherViewController: UIViewController {
    var city = ""
    var temperature = ""
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        
        loadData()
        cityLabel.text = city
        temperatureLabel.text = temperature
        cityLabel.isHidden = true
        temperatureLabel.isHidden = true
        iconImage.isHidden = true
        descriptionLabel.isHidden = true
        activityIndicator.startAnimating()
    }
    
    private func loadData() {
            DataManager.shared.getWeather(city: city, {weatherData in
                DispatchQueue.main.async { [self] in
                    if weatherData.message == "city not found" {
                        descriptionLabel.text = "Такой город не найден"
                        cityLabel.isHidden = false
                        descriptionLabel.isHidden = false
                        activityIndicator.stopAnimating()
                        activityIndicator.isHidden = true
                    }
                    guard let weather = weatherData.weather else { return }
                    guard let main = weatherData.main else { return }
                        iconImage.image = UIImage(named: getIcon(icon: weather[0].main))
                        print(weather[0].main)
                        descriptionLabel.text = weather[0].description
                        temperatureLabel.text = "\(Int(main.temp))\(UnitTemperature.celsius.symbol)"
                        activityIndicator.stopAnimating()
                        activityIndicator.isHidden = true
                        cityLabel.isHidden = false
                        temperatureLabel.isHidden = false
                        iconImage.isHidden = false
                        descriptionLabel.isHidden = false
                }
            })
    }
    
    private func getIcon(icon: String) -> String{
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

