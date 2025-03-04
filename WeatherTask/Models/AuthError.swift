//
//  AuthError.swift
//  WeatherTask
//
//  Created by Michael Winkler on 03.03.25.
//

import Foundation

enum AuthError: Error {
        case invalidEmail
        case incorrectCredentials
        case weakPassword
        case emailAlreadyInUse
        case networkError
        case unknownError

        var errorDescription: String? {
            switch self {
            case .invalidEmail: return "Bitte geben Sie eine gültige E-Mail-Adresse ein."
            case .incorrectCredentials: return "Login fehlgeschlagen."
            case .weakPassword: return "Passwort ist zu schwach."
            case .emailAlreadyInUse: return "E-Mail wird bereits verwendet."
            case .networkError: return "Netzwerkfehler."
            case .unknownError: return "Ein unbekannter Fehler ist aufgetreten."
            }
        }
    }
