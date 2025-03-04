//
//  WeatherData.swift
//  WeatherTask
//
//  Created by Michael Winkler on 03.03.25.
//

import Foundation
import CoreLocation

struct WeatherData: Codable {
    let coord: Coordinates
    let weather: [Weather]
    let main: Main
    let wind: Wind
    let clouds: Clouds
    let visibility: Int
    let dt: Int
    let sys: Sys
    let timezone: Int
    let name: String

    struct Coordinates: Codable {
        let lon: Double
        let lat: Double
    }

    struct Main: Codable {
        let temp: Double
        let feelsLike: Double
        let pressure: Int
        let humidity: Int
        
        enum CodingKeys: String, CodingKey {
            case temp, pressure, humidity
            case feelsLike = "feels_like"
        }
    }

    struct Weather: Codable {
        let main: String
        let description: String
        let icon: String
    }

    struct Wind: Codable {
        let speed: Double
        let deg: Int
    }

    struct Clouds: Codable {
        let all: Int
    }

    struct Sys: Codable {
        let country: String
        let sunrise: Int
        let sunset: Int
    }
}

extension WeatherData {
    init(from response: WeatherResponse) {
        self.coord = Coordinates(lon: response.coord.lon, lat: response.coord.lat)
        self.weather = response.weather
        self.main = Main(
            temp: response.main.temp,
            feelsLike: response.main.feelsLike,
            pressure: response.main.pressure,
            humidity: response.main.humidity
        )
        self.wind = response.wind
        self.clouds = response.clouds
        self.visibility = response.visibility
        self.dt = response.dt
        self.sys = response.sys
        self.timezone = response.timezone
        self.name = response.name
    }
}
