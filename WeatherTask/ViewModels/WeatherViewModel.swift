//
//  WeatherViewModel.swift
//  WeatherTask
//
//  Created by Michael Winkler on 17.02.25.
//

import Foundation
import Combine
import CoreLocation
import SwiftUI

@MainActor
class WeatherViewModel: ObservableObject {
    @Published var weather: WeatherData?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let weatherService = WeatherService()
    private let locationManager = LocationManager()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchWeather()
    }
    
    func fetchWeather() {
        isLoading = true
        errorMessage = nil
        
        locationManager.$currentLocation
            .compactMap { $0 }
            .first()
            .flatMap { location in
                self.weatherService.getWeather(for: location)
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { weatherData in
                self.weather = weatherData
            })
            .store(in: &cancellables)
    }
    
    func formattedTemperature() -> String {
        guard let temp = weather?.temperature else { return "--°C" }
        return String(format: "%.1f°C", temp)
    }
    
    func weatherIcon() -> String {
        guard let condition = weather?.condition else { return "cloud.fill" }
        return WeatherIconProvider.getIcon(for: condition)
    }
}

//import Foundation
//import CoreLocation
//
//@MainActor
//class WeatherViewModel: ObservableObject {
//    @Published var weatherInfo: String = "Noch keine Daten"
//    
//    private let weatherService = WeatherService()
//    private let locationManager = LocationManager()
//    
//    init() {
//        Task {
//            await locationManager.requestLocation()
//        }
//    }
//    
//    func fetchWeather() async {
//        do {
//            while locationManager.location == nil {
//                try await Task.sleep(nanoseconds: 500_000_000) // 0,5 Sekunden warten
//            }
//            
//            if let location = locationManager.location {
//                let weather = try await weatherService.fetchWeather(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
//                self.weatherInfo = "🌡 \(weather.main.temp)°C - \(weather.weather.first?.description ?? "")"
//            } else {
//                self.weatherInfo = "Standort nicht verfügbar"
//            }
//        } catch {
//            self.weatherInfo = "Fehler: \(error.localizedDescription)"
//        }
//    }
//}
