//
//  WeatherTestView.swift
//  WeatherTask
//
//  Created by Michael Winkler on 03.03.25.
//

import SwiftUI

struct WeatherTestView: View {
    @StateObject var locationManager = LocationManager()
    var weatherManager = WeatherAPIService()
    @State var weather: ResponseData?
    @StateObject private var weatherViewModel = WeatherViewModel()
    
    var body: some View {
        VStack {
            Text(weatherViewModel.weatherInfo)
                .padding()
            
            Button("Wetter für aktuellen Standort") {
                Task {
                    weatherViewModel.getWeatherForecast()
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
