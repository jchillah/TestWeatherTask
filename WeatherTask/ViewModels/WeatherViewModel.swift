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
import SwiftData
import OSLog
import FirebaseAuth

@MainActor
class WeatherViewModel: ObservableObject {
    @Published var temperature: String = "--"
    @Published var condition: String = "--"
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var weatherData: WeatherData?
    
    private let weatherService = WeatherAPIService()
    let locationManager = LocationManager()
    private var cancellables = Set<AnyCancellable>()
    
    // SwiftData-Manager (wird über den Initializer gesetzt)
    var weatherDataManager: WeatherDataManager?
    var firestoreWeatherManager: FirestoreWeatherManager?
    
    // Logger für strukturiertes Logging
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "WeatherTask", category: "WeatherViewModel")
    
    // Initialisiere das ViewModel mit optionalem ModelContext
    init(modelContext: ModelContext? = nil) {
        if let context = modelContext {
            weatherDataManager = WeatherDataManager(modelContext: context)
        }
        firestoreWeatherManager = FirestoreWeatherManager()
        // Beobachte den Standort und lade Wetterdaten, wenn sich der Standort ändert
        locationManager.$location
            .compactMap { $0?.coordinate }
            .sink { [weak self] coordinate in
                self?.fetchWeatherCoords(for: coordinate)
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
    func fetchWeatherCoords(for coordinate: CLLocationCoordinate2D) {
        isLoading = true
        Task {
            do {
                // Abruf der Wetterdaten via APIService (async/await)
                let weatherResponse: WeatherResponse = try await weatherService.fetchWeather(for: coordinate)
                let data = WeatherData(from: weatherResponse)
                
                
                // Da wir uns bereits im MainActor befinden, sind UI-Updates direkt möglich.
                self.weatherData = data
                self.temperature = WeatherFormatter.formatTemperature(weatherResponse.main.temp)
                self.condition = weatherResponse.weather.first?.description.capitalized ?? "--"
                self.errorMessage = nil
                
                // Speichere die Wetterdaten in SwiftData, falls der Manager verfügbar ist
                weatherDataManager?.saveWeatherData(data)
                
                // Speichere in Firestore (sofern ein User angemeldet ist)
                if let userID = Auth.auth().currentUser?.uid {
                    firestoreWeatherManager?.saveWeatherData(data, forUser: userID)
                }
                
                logger.info("✅ Wetterdaten erfolgreich geladen und gespeichert.")
            } catch {
                self.errorMessage = error.localizedDescription
                logger.error("❌ Fehler beim Laden der Wetterdaten: \(error.localizedDescription, privacy: .public)")
            }
            isLoading = false
        }
    }
    
    /// Beispiel-Funktion, um Wetterdaten über einen Stadtnamen abzurufen (async/await)
    func fetchWeatherCityName(for city: String) async {
        let apiKey = APIKeyManager.loadAPIKey()
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
        guard let url = URL(string: urlString) else {
            logger.error("Ungültige URL: \(urlString, privacy: .public)")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(WeatherResponse.self, from: data)
            let convertedData = WeatherData(from: response)
            self.weatherData = convertedData
            weatherDataManager?.saveWeatherData(convertedData)
            if let userID = Auth.auth().currentUser?.uid {
                firestoreWeatherManager?.saveWeatherData(convertedData, forUser: userID)
            }
            logger.info("✅ Wetterdaten für \(city, privacy: .public) erfolgreich geladen und gespeichert.")
        } catch {
            logger.error("❌ Fehler beim Abrufen der Wetterdaten für \(city, privacy: .public): \(error.localizedDescription, privacy: .public)")
        }
    }
    
    /// Beispiel für einen Callback-basierten API-Aufruf (nicht async/await)
    func fetchWeatherCallback(lat: Double, lon: Double) {
        isLoading = true
        errorMessage = nil
        
        APIService.shared.getJSON(
            endpoint: "weather",
            parameters: ["lat": "\(lat)", "lon": "\(lon)", "units": "metric", "lang": "de"]
        ) { (result: Result<WeatherData, APIService.APIError>) in
            switch result {
            case .success(let weather):
                self.weatherData = weather
                self.weatherDataManager?.saveWeatherData(weather)
                if let userID = Auth.auth().currentUser?.uid {
                    self.firestoreWeatherManager?.saveWeatherData(weather, forUser: userID)
                }
                self.logger.info("✅ Wetterdaten erfolgreich über Callback geladen und gespeichert.")
            case .failure(let error):
                self.errorMessage = "Fehler: \(error)"
                self.logger.error("❌ Fehler beim Callback-Abruf: \(error.localizedDescription, privacy: .public)")
            }
            self.isLoading = false
        }
    }
}
