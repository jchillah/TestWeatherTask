//
//  WeatherFormatter.swift
//  WeatherTask
//
//  Created by Michael Winkler on 03.03.25.
//


import Foundation

struct WeatherFormatter {
    static func formatTemperature(_ temperature: Double) -> String {
        return String(format: "%.1f°C", temperature)
    }
    
    static func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, dd MMM yyyy"
        return formatter.string(from: date)
    }
}
