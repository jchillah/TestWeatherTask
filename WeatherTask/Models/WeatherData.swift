//
//  WeatherData.swift
//  WeatherTask
//
//  Created by Michael Winkler on 03.03.25.
//

import Foundation

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
    let id: Int
    let base: String
    let cod: Int

    struct Coordinates: Codable {
        let lon: Double
        let lat: Double
    }

    struct Weather: Codable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }

    struct Main: Codable {
        let temp: Double
        let feelsLike: Double
        let tempMin: Double
        let tempMax: Double
        let pressure: Int
        let humidity: Int
        let seaLevel: Int?
        let groundLevel: Int?

        enum CodingKeys: String, CodingKey {
            case temp
            case feelsLike = "feels_like"
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            case pressure
            case humidity
            case seaLevel = "sea_level"
            case groundLevel = "grnd_level"
        }
    }

    struct Wind: Codable {
        let speed: Double
        let deg: Int
        let gust: Double?
    }

    struct Clouds: Codable {
        let all: Int
    }

    struct Sys: Codable {
        let type: Int?
        let id: Int?
        let country: String
        let sunrise: Int
        let sunset: Int
    }
}

extension WeatherData {
    init(from response: WeatherResponse) {
        self.coord = Coordinates(lon: response.coord.lon, lat: response.coord.lat)
        self.weather = response.weather.map { Weather(id: $0.id, main: $0.main, description: $0.description, icon: $0.icon) }
        self.main = Main(
            temp: response.main.temp,
            feelsLike: response.main.feelsLike,
            tempMin: response.main.tempMin,
            tempMax: response.main.tempMax,
            pressure: response.main.pressure,
            humidity: response.main.humidity,
            seaLevel: response.main.seaLevel,
            groundLevel: response.main.grndLevel
        )
        self.wind = Wind(speed: response.wind.speed, deg: response.wind.deg, gust: response.wind.gust)
        self.clouds = Clouds(all: response.clouds.all)
        self.visibility = response.visibility
        self.dt = response.dt
        self.sys = Sys(
            type: response.sys.type,
            id: response.sys.id,
            country: response.sys.country,
            sunrise: response.sys.sunrise,
            sunset: response.sys.sunset
        )
        self.timezone = response.timezone
        self.name = response.name
        self.id = response.id
        self.base = response.base
        self.cod = response.cod
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "coord": ["lon": self.coord.lon, "lat": self.coord.lat],
            "weather": self.weather.map { ["id": $0.id, "main": $0.main, "description": $0.description, "icon": $0.icon] },
            "main": [
                "temp": self.main.temp,
                "feels_like": self.main.feelsLike,
                "temp_min": self.main.tempMin,
                "temp_max": self.main.tempMax,
                "pressure": self.main.pressure,
                "humidity": self.main.humidity,
                "sea_level": self.main.seaLevel ?? NSNull(),
                "grnd_level": self.main.groundLevel ?? NSNull()
            ],
            "wind": [
                "speed": self.wind.speed,
                "deg": self.wind.deg,
                "gust": self.wind.gust ?? NSNull()
            ],
            "clouds": ["all": self.clouds.all],
            "visibility": self.visibility,
            "dt": self.dt,
            "sys": [
                "type": self.sys.type ?? NSNull(),
                "id": self.sys.id ?? NSNull(),
                "country": self.sys.country,
                "sunrise": self.sys.sunrise,
                "sunset": self.sys.sunset
            ],
            "timezone": self.timezone,
            "name": self.name,
            "id": self.id,
            "base": self.base,
            "cod": self.cod
        ]
    }
}
