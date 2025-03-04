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
import SwiftData  // Importiere SwiftData, wenn du es verwendest

@MainActor
class WeatherViewModel: ObservableObject {
    @Published var temperature: String = "--"
    @Published var condition: String = "--"
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var weatherData: WeatherData?
    
    private let weatherService = WeatherAPIService()
    private let locationManager = LocationManager()
    private var cancellables = Set<AnyCancellable>()
    
    // SwiftData-Manager, der den ModelContext nutzt (wird über den Initializer gesetzt)
    var weatherDataManager: WeatherDataManager?
    
    // Initialisiere das ViewModel mit einem optionalen ModelContext (aus der View)
    init(modelContext: ModelContext? = nil) {
        if let context = modelContext {
            weatherDataManager = WeatherDataManager(modelContext: context)
        }
        
        // Beobachte den Standort und lade Wetterdaten, wenn er sich ändert
        locationManager.$location
            .compactMap { $0?.coordinate }
            .sink { [weak self] coordinate in
                self?.fetchWeather(for: coordinate)
            }
            .store(in: &cancellables)
    }
    
    var weatherInfo: String {
        guard let weatherData = weatherData else { return "Keine Wetterdaten verfügbar." }
        return """
        🌍 Ort: \(weatherData.name)
        🌡 Temperatur: \(weatherData.main.temp)°C
        🤗 Gefühlte Temperatur: \(weatherData.main.feelsLike)°C
        🌤 Zustand: \(weatherData.weather.first?.description.capitalized ?? "--")
        💨 Wind: \(weatherData.wind.speed) m/s
        💦 Luftfeuchtigkeit: \(weatherData.main.humidity)%
        """
    }
    
    /// Lädt die Wetterdaten für die übergebenen Koordinaten und speichert sie in SwiftData
    func fetchWeather(for coordinate: CLLocationCoordinate2D) {
        isLoading = true
        Task {
            do {
                // Abruf der Wetterdaten via APIService (mit async/await)
                let weatherResponse: WeatherResponse = try await weatherService.fetchWeather(for: coordinate)
                // Konvertiere die API-Response in dein internes Modell WeatherData
                let data = WeatherData(from: weatherResponse)
                
                // UI-Updates und Speicherung immer im Main-Thread
                DispatchQueue.main.async {
                    self.weatherData = data
                    self.temperature = WeatherFormatter.formatTemperature(weatherResponse.main.temp)
                    self.condition = weatherResponse.weather.first?.description.capitalized ?? "--"
                    self.errorMessage = nil
                    
                    // Speichere die Wetterdaten in SwiftData, falls der Manager verfügbar ist
                    self.weatherDataManager?.saveWeatherData(data)
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
            }
            isLoading = false
        }
    }
    
    /// Beispiel-Funktion, um Wetterdaten über einen Stadtnamen abzurufen (async/await)
    func fetchWeather(for city: String) async {
        let apiKey = "DEIN_API_KEY"
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
        guard let url = URL(string: urlString) else {
            print("Ungültige URL")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(WeatherResponse.self, from: data)
            DispatchQueue.main.async {
                let data = WeatherData(from: response)
                self.weatherData = data
                // Speichern in SwiftData
                self.weatherDataManager?.saveWeatherData(data)
            }
        } catch {
            print("Fehler beim Abrufen der Wetterdaten: \(error.localizedDescription)")
        }
    }
    
    /// Beispiel für einen Callback-basierten API-Aufruf
    func fetchWeather1(lat: Double, lon: Double) {
        isLoading = true
        errorMessage = nil
        
        APIService.shared.getJSON(
            endpoint: "weather",
            parameters: ["lat": "\(lat)", "lon": "\(lon)", "units": "metric", "lang": "de"]
        ) { (result: Result<WeatherData, APIService.APIError>) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let weather):
                    self.weatherData = weather
                    // Speichere in SwiftData, falls der Manager verfügbar ist
                    self.weatherDataManager?.saveWeatherData(weather)
                case .failure(let error):
                    self.errorMessage = "Fehler: \(error)"
                }
            }
        }
    }
}
