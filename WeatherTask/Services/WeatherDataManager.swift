//
//  WeatherDataManager.swift
//  WeatherTask
//
//  Created by Michael Winkler on 04.03.25.
//


import SwiftData
import Foundation

class WeatherDataManager {
    let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func saveWeatherData(_ weatherData: WeatherData) {
        let entity = WeatherEntity.from(weatherData: weatherData)
        
        // Prüfen, ob die Wetterdaten bereits existieren, um doppelte Einträge zu vermeiden
        let fetchDescriptor = FetchDescriptor<WeatherEntity>(predicate: #Predicate { $0.id == weatherData.id })
        if let existingWeather = try? modelContext.fetch(fetchDescriptor).first {
            modelContext.delete(existingWeather)
        }

        modelContext.insert(entity)

        do {
            try modelContext.save()
            print("✅ Wetterdaten erfolgreich in SwiftData gespeichert!")
        } catch {
            print("❌ Fehler beim Speichern der Wetterdaten: \(error)")
        }
    }
}
