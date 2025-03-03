//
//  WeatherService.swift
//  WeatherTask
//
//  Created by Michael Winkler on 17.02.25.
//

import Foundation
import CoreLocation

struct WeatherService {
    private let apiKey = "YOUR_API_KEY"
    private let baseURL = "https://api.openweathermap.org/data/2.5/forecast"

    func fetchWeather(for location: CLLocationCoordinate2D) async throws -> WeatherResponse {
        let urlString = "\(baseURL)?lat=\(location.latitude)&lon=\(location.longitude)&appid=\(apiKey)&units=metric"
        guard let url = URL(string: urlString) else {
            throw WeatherServiceError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw WeatherServiceError.invalidResponse
        }

        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            let weatherResponse = try decoder.decode(WeatherResponse.self, from: data)
            return weatherResponse
        } catch {
            throw WeatherServiceError.decodingError(error)
        }
    }
}

enum WeatherServiceError: Error {
    case invalidURL
    case invalidResponse
    case decodingError(Error)
}
