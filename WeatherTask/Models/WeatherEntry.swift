//
//  WeatherEntry.swift
//  WeatherTask
//
//  Created by Michael Winkler on 04.03.25.
//

import Foundation
import SwiftUI

// Verwende eigene Aliase, um Konflikte zu vermeiden
typealias EntryMain = WeatherData.Main
typealias EntryWeather = WeatherData.Weather

struct WeatherEntry: Codable {
    let main: EntryMain
    let weather: [EntryWeather]
    let dt: Int
    
    var date: Date {
        Date(timeIntervalSince1970: TimeInterval(dt))
    }
}
