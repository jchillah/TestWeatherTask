//
//  WeatherViewModel.swift
//  WeatherTask
//
//  Created by Michael Winkler on 17.02.25.
//

import Foundation
import CoreLocation
import SwiftUI
import Combine

@MainActor
class WeatherViewModel: ObservableObject {
    @Published var temperature: String = "--"
    @Published var condition: String = "--"
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let weatherService = WeatherAPIService()
    private let locationManager = LocationManager()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        locationManager.$location
            .compactMap { $0?.coordinate }
            .sink { [weak self] location in
                self?.fetchWeather(for: location)
            }
            .store(in: &cancellables)
    }
    
    func fetchWeather(for coordinate: CLLocationCoordinate2D) {
        isLoading = true
        Task {
            do {
                let weatherResponse = try await weatherService.fetchWeather(for: coordinate)
                if let firstWeather = weatherResponse.list.first {
                    temperature = WeatherFormatter.formatTemperature(firstWeather.main.temp)
                    condition = firstWeather.weather.first?.description.capitalized ?? "--"
                }
                errorMessage = nil
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
}

//@MainActor
//class WeatherViewModel: ObservableObject {
//    @Published var weatherInfo: String = "Noch keine Daten"
//    @Published var isLoading: Bool = false
//    @Published var authError: AuthError?
//    @Published var temperature: String = "--"
//    @Published var condition: String = "--"
//
//    private let weatherService = WeatherAPIService()
//    private let locationManager = LocationManager()
//    private var cancellables = Set<AnyCancellable>()
//
//    init() {
//        locationManager.$location
//            .compactMap { $0?.coordinate } // Konvertiert CLLocation zu CLLocationCoordinate2D
//            .sink { [weak self] location in
//                self?.fetchWeather(for: location)
//            }
//            .store(in: &cancellables)
//
//    }
//
//    func fetchWeather(for coordinate: CLLocationCoordinate2D) {
//        isLoading = true
//        Task {
//            do {
//                let weatherResponse = try await weatherService.fetchWeather(for: coordinate)
//                if let firstWeather = weatherResponse.list.first {
//                    temperature = "\(firstWeather.main.temp)°C"
//                    condition = firstWeather.weather.first?.description.capitalized ?? "--"
//                }
//                isLoading = false
//            } catch {
//                authError = AuthError(errorString: error.localizedDescription)
//                isLoading = false
//            }
//        }
//    }
//}
