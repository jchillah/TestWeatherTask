//
////
////  WeatherTestView 2.swift
////  WeatherTask
////
////  Created by Michael Winkler on 04.03.25.
////
//import SwiftUI
//
//struct WeatherTestView: View {
//    @Environment(\.modelContext) private var modelContext
//    @StateObject private var viewModel = WeatherViewModel(modelContext: modelContext)
//    
//    var body: some View {
//        VStack {
//            if viewModel.isLoading {
//                ProgressView("Lade Wetterdaten…")
//            } else if let error = viewModel.errorMessage {
//                Text("Fehler: \(error)")
//            } else if let weather = viewModel.weatherData {
//                Text(viewModel.weatherInfo)
//                    .padding()
//            }
//            
//            Button("Wetter für aktuellen Standort") {
//                Task {
//                    if let coordinate = viewModel.locationManager.location?.coordinate {
//                        viewModel.fetchWeather(for: coordinate)
//                    }
//                }
//            }
//            .padding()
//        }
//    }
//}
