//
//  WeatherTestView.swift
//  WeatherTask
//
//  Created by Michael Winkler on 03.03.25.
//

import SwiftUI
import SwiftData

struct WeatherTestView: View {
    @EnvironmentObject var locationManager: LocationManager
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: WeatherViewModel
    @State private var errorMessage: String? = nil


    init() {
        // Initialisiere das ViewModel zunächst ohne modelContext
        _viewModel = StateObject(wrappedValue: WeatherViewModel(modelContext: nil))
    }
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Lade Wetterdaten…")
            } else if let error = viewModel.errorMessage {
                Text("Fehler: \(error)")
                    .foregroundColor(.red)
                    .padding()
            } else if viewModel.weatherData != nil {
                Text(viewModel.weatherInfo)
                    .padding()
            }
            
            Button("Wetter für aktuellen Standort") {
                            Task {
                                if let coordinate = locationManager.location?.coordinate {
                                    viewModel.fetchWeather(for: coordinate)
                                    errorMessage = nil
                                } else {
                                    errorMessage = "Kein Standort verfügbar. Bitte Standort aktivieren."
                                }
                            }
                        }
                        .padding()

                        if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .padding()
                        }
        }
        .onAppear {
            // Hier setzen wir den ModelContext, sodass unser WeatherDataManager im ViewModel initialisiert werden kann
            viewModel.weatherDataManager = WeatherDataManager(modelContext: modelContext)
        }
    }
}

#Preview {
    WeatherTestView()
}


//
//import SwiftUI
//
//struct WeatherTestView: View {
//    @StateObject var locationManager = LocationManager()
//    @StateObject private var weatherViewModel = WeatherViewModel()
//
//    var body: some View {
//        VStack {
//            Text(weatherViewModel.weatherInfo)
//                .padding()
//
//            Button("Wetter für aktuellen Standort") {
//                Task {
//                    if let coordinate = locationManager.location?.coordinate {
//                        weatherViewModel.fetchWeather(for: coordinate)
//                    } else {
//                        print("Kein Standort verfügbar")
//                    }
//                }
//            }
//            .padding()
//            .buttonStyle(.borderedProminent)
//        }
//    }
//}
//
//#Preview {
//    WeatherTestView()
//}
