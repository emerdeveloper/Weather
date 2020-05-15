//
//  WeatherData.swift
//  Weather
//
//  Created by Emerson Javid Gonzalez Morales on 14/05/20.
//  Copyright © 2020 Emerson Javid Gonzalez Morales. All rights reserved.
//

import Foundation

struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: Array<Weather>
    
    var city: String {
        name
    }
    
    var temperature: String {
        String.init(format: "%.1f", main.temp)
    }
    
    var description: String {
        weather[0].description
    }
    
    var conditionName: String {
        switch weather[0].id {
        case 200...232:
            return "cloud.bolt.rain"
        case 300...321:
            return "cloud.heavyrain"
        case 500...504:
            return "cloud.rain"
        case 511:
            return "cloud.snow"
        case 520...531:
            return "cloud.fog"
        case 600...622:
            return "cloud.snow"
        case 700...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801:
            return "cloud.sun"
        case 802...804:
            return "cloud"
        default:
            return "cloud"
        }
    }
}

struct Main: Decodable {
    let temp: Double
}

struct Weather: Decodable {
    let description: String
    let id: Int
}
