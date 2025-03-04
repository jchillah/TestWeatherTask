//
//  WeatherRepositoryProtocol.swift
//  WeatherTask
//
//  Created by Michael Winkler on 03.03.25.
//

import Foundation
import CoreLocation

protocol WeatherRepositoryProtocol {
    func fetchWeather(for location: CLLocationCoordinate2D) async throws -> WeatherData
}

class WeatherRepository: WeatherRepositoryProtocol {
    func fetchWeather(for location: CLLocationCoordinate2D) async throws -> WeatherData {
        let apiKey = APIKeyManager.loadAPIKey() // 🔥 Hier wird der API-Key geladen
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(location.latitude)&lon=\(location.longitude)&appid=\(apiKey)&units=metric&lang=de"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decodedResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
        return WeatherData(from: decodedResponse)
    }
}


//import Foundation
//
//protocol WeatherRepositoryProtocol {
//    func fetchWeather(for location: String) async throws -> WeatherData
//}
//
//final class WeatherRepository: WeatherRepositoryProtocol {
//    private let apiService: WeatherAPIService
//    
//    init(apiService: WeatherAPIService = WeatherAPIService()) {
//        self.apiService = apiService
//    }
//    
//    func fetchWeather(for location: String) async throws -> WeatherData {
//        return try await apiService.fetchWeather(for: location)
//    }
//}
