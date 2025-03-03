//
//  WeatherService.swift
//  WeatherTask
//
//  Created by Michael Winkler on 17.02.25.
//

import Foundation

@MainActor
class WeatherService {
    private let apiKey = Secrets.apiKey
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    
    // Wetter mit GPS-Koordinaten abrufen.
    func fetchWeather(lat: Double, lon: Double) async throws -> WeatherData {
        let urlString = "\(baseURL)?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric"
        return try await fetch(urlString: urlString)
    }
    
    // Wetter mit Ortsnamen abrufen
    func fetchWeather(for city: String) async throws -> WeatherData {
        let urlString = "\(baseURL)?q=\(city)&appid=\(apiKey)&units=metric"
        return try await fetch(urlString: urlString)
    }
    
    private func fetch(urlString: String) async throws -> WeatherData {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(WeatherData.self, from: data)
    }
}
