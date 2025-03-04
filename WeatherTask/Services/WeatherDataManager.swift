//
//  WeatherDataManager.swift
//  WeatherTask
//
//  Created by Michael Winkler on 04.03.25.
//

import SwiftData
import Foundation
import OSLog

class WeatherDataManager {
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "WeatherDataManager", category: "WeatherDataManager")
    let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func saveWeatherData(_ weatherData: WeatherData) {
        let entity = WeatherEntity.from(weatherData: weatherData)
        
        // Prüfen, ob bereits ein Eintrag mit derselben ID existiert, um Duplikate zu vermeiden
        let fetchDescriptor = FetchDescriptor<WeatherEntity>(predicate: #Predicate { $0.id == weatherData.id })
        if let existingWeather = try? modelContext.fetch(fetchDescriptor).first {
            modelContext.delete(existingWeather)
        }

        modelContext.insert(entity)

        do {
            try modelContext.save()
            logger.info("✅ Wetterdaten erfolgreich in SwiftData gespeichert!")
        } catch {
                   logger.error("❌ Fehler beim Speichern der Wetterdaten: \(error.localizedDescription)")
        }
    }
}
