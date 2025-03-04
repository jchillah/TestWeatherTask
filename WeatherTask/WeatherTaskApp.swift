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
    // Integriere den AppDelegate, der das Protokoll erfüllt:
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @StateObject var locationManager = LocationManager()
    
    var body: some Scene {
        WindowGroup {
            WeatherTestView()
                .environmentObject(locationManager)
        }
    }
}
