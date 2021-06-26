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
    var weatherData: WeatherData?
    let dataManager = DataManager()
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        
        getWeather(city: city)
        cityLabel.text = city
        temperatureLabel.text = temperature
        cityLabel.isHidden = true
        temperatureLabel.isHidden = true
        iconImage.isHidden = true
        descriptionLabel.isHidden = true
        activityIndicator.startAnimating()
    }
    
    private func getWeather(city: String){
        if let url = URL(string: ("\(dataManager.getUrl)&q=\(city)").encodeUrl) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        self.weatherData = try decoder.decode(WeatherData.self, from: data)
                        DispatchQueue.main.async { [self] in
                            guard let weatherData = self.weatherData else { return }
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
                                //iconImage.image = getIconFromUrl(url: weather[0].icon)
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
                    } catch {
                        print(error)
                    }
                }
           }.resume()
        }
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
        default:
            return "sun"
        }
    }
    
    private func getIconFromUrl(url: String) -> UIImage? {
        let url = URL(string: "https://openweathermap.org/img/wn/\(url)@2x.png")
        do{
            let data = try Data(contentsOf: url!)
            return UIImage(data: data)
        } catch {
            print(error)
        }
        return UIImage(named: "sun")
    }
    
}

