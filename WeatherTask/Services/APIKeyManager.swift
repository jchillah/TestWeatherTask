//
//  APIKeyManager.swift
//  WeatherTask
//
//  Created by Michael Winkler on 04.03.25.
//

import Foundation

struct APIKeyManager {
    static func loadAPIKey() -> String {
        guard let apiKey = ProcessInfo.processInfo.environment[Secrets.apiKey] else {
            fatalError("Fehlender OpenWeather API-Schlüssel. Setze die 'OPEN_WEATHER_API_KEY' Umgebungsvariable.")
        }
        return apiKey
    }
}
