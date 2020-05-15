//
//  ViewController.swift
//  Weather
//
//  Created by Emerson Javid Gonzalez Morales on 14/05/20.
//  Copyright © 2020 Emerson Javid Gonzalez Morales. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var buttonLocation: UIButton!
    @IBOutlet weak var buttonSearch: UIButton!
    @IBOutlet weak var textFieldSearch: UITextField!
    @IBOutlet weak var labelTemperature: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var ImageCondition: UIImageView!
    @IBOutlet weak var labelDescription: UILabel!
    
    
    var managerAPI = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.requestLocation()
                
        textFieldSearch.delegate = self
        managerAPI.delegate = self
    }
    
    @IBAction func getLocationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
}

//MARK: - UITextFieldDelegate

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        search()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textFieldSearch.text != "" {
            textFieldSearch.placeholder = "Search"
            return true
        } else {
            textFieldSearch.placeholder = "Type something"
            return false
        }
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        search()
    }
    
    func search() {
        textFieldSearch.endEditing(true)
        if let city = textFieldSearch.text {
            managerAPI.fetchWeather(city: city)
        }
        
        textFieldSearch.text = ""
    }
}

//MARK: - WeatherDelegate

extension ViewController: WeatherDelegate {
    func didUpdateWeather(weatherData: WeatherData) {
        DispatchQueue.main.async {
            self.labelTemperature.text = weatherData.temperature
            self.ImageCondition.image = UIImage(systemName: weatherData.conditionName)
            self.labelLocation.text = weatherData.city
            self.labelDescription.text = weatherData.description
        }
    }
    
    func didFaildWithError(_ error: Error) {
        DispatchQueue.main.async {
            if let city = self.textFieldSearch.text {
                self.labelLocation.text = "\(city) not found"
            }
        }
    }
}

//MARK: - LocationManagerDelegate

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location  = locations.last {
            managerAPI.fetchWeather(latitude: String(location.coordinate.latitude),
                                    longitude: String(location.coordinate.longitude))
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
