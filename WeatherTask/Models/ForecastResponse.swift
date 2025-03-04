//
//  ForecastResponse.swift
//  WeatherTask
//
//  Created by Michael Winkler on 04.03.25.
//


import Foundation
import SwiftUI

struct ForecastResponse: Codable {
    let list: [WeatherEntry]
}
