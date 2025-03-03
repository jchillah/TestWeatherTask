//
//  WeatherResponse.swift
//  WeatherTask
//
//  Created by Michael Winkler on 17.02.25.
//

import Foundation

struct WeatherResponse: Codable {
    let list: [WeatherEntry]
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
}

struct WeatherInfo: Codable {
    let description: String
}
