//
//  ErrorHandler.swift
//  WeatherTask
//
//  Created by Michael Winkler on 14.02.25.
//

import Foundation

@MainActor
class ErrorHandler: ObservableObject {
    @Published var errorMessage: String?
    
    func handle(error: Error) {
        if let localizedError = error as? LocalizedError, let description = localizedError.errorDescription {
            errorMessage = description
        } else {
            errorMessage = "Ein unbekannter Fehler ist aufgetreten."
        }
    }
    
    func clearError() {
        errorMessage = nil
    }
}
