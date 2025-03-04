//
//  WeatherTaskApp.swift
//  WeatherTask
//
//  Created by Michael Winkler on 15.02.25.
//

import SwiftUI
import FirebaseCore

@main
struct WeatherTaskApp: App {
    @StateObject var locationManager = LocationManager()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            WeatherTestView()
                .environmentObject(locationManager)
        }
    }
}
