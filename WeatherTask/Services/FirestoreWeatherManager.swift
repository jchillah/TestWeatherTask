//
//  FirestoreWeatherManager.swift
//  WeatherTask
//
//  Created by Michael Winkler on 04.03.25.
//


import FirebaseFirestore
import Foundation

class FirestoreWeatherManager {
    private let db = Firestore.firestore()
    
    func saveWeatherData(_ weatherData: WeatherData, forUser userID: String) {
        let weatherDict = weatherData.toDictionary()
        let documentID = "\(weatherData.id)"
        
        db.collection("users")
            .document(userID)
            .collection("weather")
            .document(documentID)
            .setData(weatherDict) { error in
                if let error = error {
                    print("❌ Fehler beim Speichern in Firestore: \(error.localizedDescription)")
                } else {
                    print("✅ Wetterdaten erfolgreich in Firestore gespeichert!")
                }
            }
    }
}
