//
//  ViewController.swift
//  WeatherApp
//
//  Created by Алексей on 25.06.2021.
//

import UIKit

class WeatherTableViewController: UITableViewController {
    
    let dataManager = DataManager()
    var cities = [""]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        cities = dataManager.cities
        tableView.allowsSelection = true
        tableView.backgroundView?.backgroundColor = UIColor(red: 117, green: 204, blue: 205, alpha: 1)
    }

    @IBAction func addCityButton(_ sender: UIBarButtonItem) {
        addCity()
    }
    @IBAction func editCityButton(_ sender: UIBarButtonItem) {
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = cities[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.tableView.isEditing = true
        if editingStyle == .delete {
            cities.remove(at: indexPath.row)
            DataManager.shared.deleteCity(city: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.cities[sourceIndexPath.row]
        cities.remove(at: sourceIndexPath.row)
        cities.insert(movedObject, at: destinationIndexPath.row)
        DataManager.shared.updateCity(cities: cities)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailWeather = segue.destination as? DetailWeatherViewController else { return }
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        detailWeather.city = cities[indexPath.row]

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
                let city = actionSheet.textFields![0] as UITextField
                guard city.text != "" else { return }
                DataManager.shared.getWeather(city: city.text!, { weatherData in
                    if weatherData.message == "city not found" {
                        let errorSheet = UIAlertController(title: "Ошибка", message: "Такой город не найден!", preferredStyle: .alert)
                        errorSheet.addAction(UIAlertAction(title: "OK", style: .cancel) { _ in
                            print("Cancel")
                        })
                        self.present(errorSheet, animated: true, completion: nil)
                    } else {
                        self.cities.append(city.text!)
                        DataManager.shared.saveCity(city: city.text!)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }


                })
            }

            actionSheet.addAction(saveActionButton)
            self.present(actionSheet, animated: true, completion: nil)
    }
}

