//
//  WeatherTestView.swift
//  WeatherTask
//
//  Created by Michael Winkler on 03.03.25.
//

import SwiftUI

struct WeatherTestView: View {
    @StateObject var locationManager = LocationManager()
    @StateObject private var weatherViewModel = WeatherViewModel()

    var body: some View {
        VStack {
            Text(weatherViewModel.weatherInfo)
                .padding()

            Button("Wetter für aktuellen Standort") {
                Task {
                    if let coordinate = locationManager.location?.coordinate {
                        weatherViewModel.fetchWeather(for: coordinate)
                    } else {
                        print("Kein Standort verfügbar")
                    }
                }
            }
            .padding()
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    WeatherTestView()
}
