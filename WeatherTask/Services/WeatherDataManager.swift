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
    let modelContext: ModelContext
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "WeatherDataManager", category: "Persistence")

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func saveWeatherData(_ weatherData: WeatherData) {
        let entity = WeatherEntity.from(weatherData: weatherData)
        
        // Verhindere doppelte Einträge
        let fetchDescriptor = FetchDescriptor<WeatherEntity>(predicate: #Predicate { $0.id == weatherData.id })
        if let existing = try? modelContext.fetch(fetchDescriptor).first {
            modelContext.delete(existing)
        }
        
        modelContext.insert(entity)
        
        do {
            try modelContext.save()
            logger.info("✅ Wetterdaten erfolgreich in SwiftData gespeichert!")
        } catch {
            logger.error("❌ Fehler beim Speichern in SwiftData: \(error.localizedDescription, privacy: .public)")
        }
    }
}
