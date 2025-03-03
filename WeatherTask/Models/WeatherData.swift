//
//  WeatherData.swift
//  WeatherTask
//
//  Created by Michael Winkler on 03.03.25.
//

import Foundation

struct WeatherData: Codable {
    let main: Main
    let weather: [Weather]
    let wind: Wind
    
    struct Main: Codable {
        let temp: Double
        let feels_like: Double
        let pressure: Int
        let humidity: Int
    }
    
    struct Weather: Codable {
        let main: String
        let description: String
    }
    
    struct Wind: Codable {
        let speed: Double
        let deg: Int
    }
}
