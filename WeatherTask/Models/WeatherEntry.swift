//
//  WeatherEntry.swift
//  WeatherTask
//
//  Created by Michael Winkler on 04.03.25.
//

import Foundation

struct WeatherEntry: Codable {
    let main: Main
    let weather: [Weather]
    let dt: Int
    
    var date: Date {
        return Date(timeIntervalSince1970: TimeInterval(dt))
    }
}
