//
//  MainView.swift
//  WeatherTask
//
//  Created by Michael Winkler on 17.02.25.
//

import SwiftUI

struct MainView: View {
    @StateObject private var weatherViewModel = WeatherViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Current Temperature: \(weatherViewModel)")
                    .font(.headline)
                    .padding()

                List {
                    Text("Task 1")
                    Text("Task 2")
                    Text("Task 3")
                }
                .listStyle(.insetGrouped)
            }
            .navigationTitle("Tasks")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {}) {
                        Image(systemName: "plus")
                    }
                }
            }
            .onAppear {
                Task {
                    weatherViewModel.fetchWeather()
                }
            }
        }
    }
}

#Preview {
    MainView()
}
