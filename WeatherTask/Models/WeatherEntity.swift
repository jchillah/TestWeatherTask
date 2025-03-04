//
//  WeatherEntity.swift
//  WeatherTask
//
//  Created by Michael Winkler on 04.03.25.
//


import SwiftData
import Foundation

@Model
class WeatherEntity {
    @Attribute(.unique) var id: Int
    var name: String
    var temperature: Double
    var feelsLike: Double
    var minTemp: Double
    var maxTemp: Double
    var pressure: Int
    var humidity: Int
    var windSpeed: Double
    var windDirection: Int
    var cloudiness: Int
    var visibility: Int
    var timezone: Int
    var country: String
    var sunrise: Date
    var sunset: Date
    var timestamp: Date

    init(id: Int, name: String, temperature: Double, feelsLike: Double, minTemp: Double, maxTemp: Double, pressure: Int, humidity: Int, windSpeed: Double, windDirection: Int, cloudiness: Int, visibility: Int, timezone: Int, country: String, sunrise: Date, sunset: Date, timestamp: Date) {
        self.id = id
        self.name = name
        self.temperature = temperature
        self.feelsLike = feelsLike
        self.minTemp = minTemp
        self.maxTemp = maxTemp
        self.pressure = pressure
        self.humidity = humidity
        self.windSpeed = windSpeed
        self.windDirection = windDirection
        self.cloudiness = cloudiness
        self.visibility = visibility
        self.timezone = timezone
        self.country = country
        self.sunrise = sunrise
        self.sunset = sunset
        self.timestamp = timestamp
    }
}

extension WeatherEntity {
    static func from(weatherData: WeatherData) -> WeatherEntity {
        return WeatherEntity(
            id: weatherData.id,
            name: weatherData.name,
            temperature: weatherData.main.temp,
            feelsLike: weatherData.main.feelsLike,
            minTemp: weatherData.main.tempMin,
            maxTemp: weatherData.main.tempMax,
            pressure: weatherData.main.pressure,
            humidity: weatherData.main.humidity,
            windSpeed: weatherData.wind.speed,
            windDirection: weatherData.wind.deg,
            cloudiness: weatherData.clouds.all,
            visibility: weatherData.visibility,
            timezone: weatherData.timezone,
            country: weatherData.sys.country,
            sunrise: Date(timeIntervalSince1970: TimeInterval(weatherData.sys.sunrise)),
            sunset: Date(timeIntervalSince1970: TimeInterval(weatherData.sys.sunset)),
            timestamp: Date(timeIntervalSince1970: TimeInterval(weatherData.dt))
        )
    }
}
