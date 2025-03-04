//  APIService.swift
//  WeatherTask
//
//  Created by Michael Winkler on 03.03.25.
//

import Foundation

public class APIService {
    public static let shared = APIService()
    
    // Definiere einen generischen Fehlertyp für deinen WeatherService.
    public enum APIError: Error {
        case invalidURL
        case networkError(_ errorString: String)
        case invalidResponse(statusCode: Int)
        case dataCorrupt
        case decodingError(_ errorString: String)
    }
    
    /// Ruft JSON-Daten von der angegebenen URL ab und decodiert sie in den gewünschten Typ T.
    public func getJSON<T: Decodable>(
        endpoint: String,
        parameters: [String: String] = [:],
        dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys,
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        // API-Key sicher laden (ersetze APIKeyManager.loadAPIKey() durch deine Methode zum Laden des Schlüssels)
        let apiKey = APIKeyManager.loadAPIKey()
        
        // Erstelle die URL-Komponenten basierend auf dem Endpunkt und den Parametern
        guard var urlComponents = URLComponents(string: "https://api.openweathermap.org/data/2.5/\(endpoint)") else {
            completion(.failure(.invalidURL))
            return
        }
        var queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        queryItems.append(URLQueryItem(name: "appid", value: apiKey))
        urlComponents.queryItems = queryItems
        
        // Erstelle die URL aus den Komponenten
        guard let url = urlComponents.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        let request = URLRequest(url: url)
        
        // Führe den Netzwerk-Call aus
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let err = error {
                completion(.failure(.networkError(err.localizedDescription)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse(statusCode: -1)))
                return
            }
            
            // Überprüfe den HTTP-Statuscode
            guard httpResponse.statusCode == 200 else {
                completion(.failure(.invalidResponse(statusCode: httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.dataCorrupt))
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = dateDecodingStrategy
            decoder.keyDecodingStrategy = keyDecodingStrategy
            
            do {
                let decodedData = try decoder.decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.decodingError(error.localizedDescription)))
            }
        }.resume()
    }
}



//
//public class APIService {
//    public static let shared = APIService()
//
//    public enum APIError: Error {
//        case invalidURL
//        case networkError(_ errorString: String)
//        case invalidResponse(statusCode: Int)
//        case dataCorrupt
//        case decodingError(_ errorString: String)
//    }
//
//    public func getJSON<T: Decodable>(
//        endpoint: String,
//        parameters: [String: String] = [:],
//        dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
//        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys,
//        completion: @escaping (Result<T, APIError>) -> Void
//    ) {
//        // API-Key sicher laden
//        let apiKey = APIKeyManager.loadAPIKey()
//
//        // Basis-URL
//        var urlComponents = URLComponents(string: "https://api.openweathermap.org/data/2.5/\(endpoint)")
//        var queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
//        queryItems.append(URLQueryItem(name: "appid", value: apiKey)) // API-Key anhängen
//        urlComponents?.queryItems = queryItems
//
//        // URL validieren
//        guard let url = urlComponents?.url else {
//            completion(.failure(.invalidURL))
//            return
//        }
//
//        let request = URLRequest(url: url)
//
//        // Netzwerk-Call mit URLSession
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let err = error {
//                completion(.failure(.networkError(err.localizedDescription)))
//                return
//            }
//
//            guard let httpResponse = response as? HTTPURLResponse else {
//                completion(.failure(.invalidResponse(statusCode: -1)))
//                return
//            }
//
//            guard httpResponse.statusCode == 200 else {
//                completion(.failure(.invalidResponse(statusCode: httpResponse.statusCode)))
//                return
//            }
//
//            guard let data = data else {
//                completion(.failure(.dataCorrupt))
//                return
//            }
//
//            let decoder = JSONDecoder()
//            decoder.dateDecodingStrategy = dateDecodingStrategy
//            decoder.keyDecodingStrategy = keyDecodingStrategy
//
//            do {
//                let decodedData = try decoder.decode(T.self, from: data)
//                completion(.success(decodedData))
//            } catch {
//                completion(.failure(.decodingError(error.localizedDescription)))
//            }
//        }.resume()
//    }
//}
