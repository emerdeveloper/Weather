//
//  WeatherManager.swift
//  Weather
//
//  Created by Emerson Javid Gonzalez Morales on 14/05/20.
//  Copyright © 2020 Emerson Javid Gonzalez Morales. All rights reserved.
//

import Foundation

protocol WeatherDelegate {
    func didUpdateWeather(weatherData: WeatherData)
    func didFaildWithError(_ error: Error)
}

struct WeatherManager {
    
    private let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=d9eb67ecc57591e62cf534391f96a27f&units=metric"
    
    var delegate: WeatherDelegate?
    
    func fetchWeather(city: String) {
        let url = "\(weatherURL)&q=\(city)"
        performRequest(with: url)
    }
    
    func fetchWeather(latitude: String, longitude: String) {
        let url = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: url)
    }
    
    private func performRequest(with urlString: String) {
        
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            
            //let task = session.dataTask(with: url, completionHandler: OnResponse)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFaildWithError(error!)
                    return
                }
                
                if let dataResponse = data {
                    if let weather = self.parseJson(weatherData: dataResponse){
                        self.delegate?.didUpdateWeather(weatherData: weather)
                    }
                }
            }
            
            task.resume()
        }
    }
    
    private func parseJson(weatherData: Data) -> WeatherData? {
        do {
            let decodedData = try JSONDecoder().decode(WeatherData.self, from: weatherData)
            return decodedData
        } catch {
            self.delegate?.didFaildWithError(error)
            return nil
        }
    }
    
    private func OnResponse(data: Data?, response: URLResponse?, error: Error?) {
        if error != nil {
            print(error!)
            return
        }
        
        if let dataResponse = data {
            print(String(data: dataResponse, encoding: .utf8)!)
        }
    }
}
