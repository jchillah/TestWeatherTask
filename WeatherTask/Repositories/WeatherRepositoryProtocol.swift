//
//  WeatherRepositoryProtocol.swift
//  WeatherTask
//
//  Created by Michael Winkler on 03.03.25.
//


import Foundation

protocol WeatherRepositoryProtocol {
    func fetchWeather(for location: String) async throws -> WeatherData
}

final class WeatherRepository: WeatherRepositoryProtocol {
    private let apiService: WeatherAPIService
    
    init(apiService: WeatherAPIService = WeatherAPIService()) {
        self.apiService = apiService
    }
    
    func fetchWeather(for location: String) async throws -> WeatherData {
        return try await apiService.getWeather(for: location)
    }
}