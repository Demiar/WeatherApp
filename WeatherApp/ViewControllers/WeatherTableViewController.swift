//
//  ViewController.swift
//  WeatherApp
//
//  Created by Алексей on 25.06.2021.
//

import UIKit

class WeatherTableViewController: UITableViewController {
    
    //let dataManager = DataManager()
    let data = DataManager.shared.dataArray

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        tableView.allowsSelection = true
        tableView.backgroundView?.backgroundColor = UIColor(red: 117, green: 204, blue: 205, alpha: 1)
    }

    @IBAction func addCityButton(_ sender: UIBarButtonItem) {
        addCity()
    }
    @IBAction func editCityButton(_ sender: UIBarButtonItem) {
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        DataManager.shared.cities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CustomTableViewCell
        if DataManager.shared.weatherDataArray.isEmpty { return cell! }
        cell?.cityLabel.text = DataManager.shared.dataArray[indexPath.row].values.first?.name
        DataManager.shared.getWeather(city: DataManager.shared.cities[indexPath.row], {weatherData in
            DispatchQueue.main.async {
                DataManager.shared.weatherDataArray.append(weatherData)
                if let weather = DataManager.shared.weatherDataArray[indexPath.row].weather {
                    if let main = DataManager.shared.weatherDataArray[indexPath.row].main {
                        cell?.temperatureLabel.text = "\(Int(main.temp))\(UnitTemperature.celsius.symbol)"
                        cell?.iconImage.image = UIImage(named: DataManager.shared.getIcon(icon: weather[0].main))
                        cell?.activityIndicator.stopAnimating()
                        cell?.activityIndicator.isHidden = true
                        cell?.cityLabel.isHidden = false
                        cell?.iconImage.isHidden = false
                        cell?.temperatureLabel.isHidden = false
                       }
                    }
                }
        })
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.tableView.isEditing = true
        if editingStyle == .delete {
            DataManager.shared.deleteCity(city: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = DataManager.shared.weatherDataArray[sourceIndexPath.row]
        DataManager.shared.weatherDataArray.remove(at: sourceIndexPath.row)
        DataManager.shared.weatherDataArray.insert(movedObject, at: destinationIndexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailWeather = segue.destination as? DetailWeatherViewController else { return }
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        detailWeather.city = DataManager.shared.cities[indexPath.row]
        print(DataManager.shared.weatherDataArray[indexPath.row].name)
        detailWeather.weatherData = DataManager.shared.weatherDataArray[indexPath.row]

    }
    
    private func loadData() {
        for city in DataManager.shared.cities {
            DataManager.shared.getWeather(city: city, { weatherData in
                DataManager.shared.dataArray.append([city: weatherData])
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
        }
        
    }
    
    private func addCity() {
            let actionSheet = UIAlertController(title: "Добавить город", message: "", preferredStyle: .alert)
        
            actionSheet.addTextField { (textField) in
                textField.placeholder = "Введите название города"
            }
        
            actionSheet.addAction(UIAlertAction(title: "Отмена", style: .cancel) { _ in
                print("Cancel")
            })

            let saveActionButton = UIAlertAction(title: "Сохранить", style: .default) { _ in
                var code = 0
                let city = actionSheet.textFields![0] as UITextField
                guard city.text != "" else { return }
                DataManager.shared.getWeather(city: city.text!, { weatherData in
                    code = 200
                    DataManager.shared.saveCity(city: city.text!)
                    DataManager.shared.weatherDataArray.append(weatherData)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                })
                if code == 200 {
                    let errorSheet = UIAlertController(title: "Ошибка", message: "Такой город не найден!", preferredStyle: .alert)
                    errorSheet.addAction(UIAlertAction(title: "OK", style: .cancel) { _ in
                        print("Cancel")
                    })
                    self.present(errorSheet, animated: true, completion: nil)
                }
            }

            actionSheet.addAction(saveActionButton)
            self.present(actionSheet, animated: true, completion: nil)
    }
}

