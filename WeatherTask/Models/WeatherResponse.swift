//
//  WeatherResponse.swift
//  WeatherTask
//
//  Created by Michael Winkler on 17.02.25.
//

import Foundation

struct WeatherResponse: Codable {
    let coord: WeatherData.Coordinates
    let weather: [WeatherData.Weather]
    let main: WeatherData.Main
    let wind: WeatherData.Wind
    let clouds: WeatherData.Clouds
    let visibility: Int
    let dt: Int
    let sys: WeatherData.Sys
    let timezone: Int
    let name: String
}

struct WeatherEntry: Codable {
    let main: MainInfo
    let weather: [WeatherInfo]
    let dt: TimeInterval
    
    var date: Date {
        return Date(timeIntervalSince1970: dt)
    }
}

struct MainInfo: Codable {
    let temp: Double
    let feels_like: Double
    let pressure: Int
    let humidity: Int
}

struct WeatherInfo: Codable {
    let main: String
    let description: String
}

struct WindInfo: Codable {
    let speed: Double
    let deg: Int
}
