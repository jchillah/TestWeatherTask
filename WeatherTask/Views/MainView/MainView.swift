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
                if weatherViewModel.isLoading {
                    ProgressView("Lade Wetterdaten...")
                } else {
                    Text("Aktuelle Temperatur: \(weatherViewModel.temperature)")
                        .font(.headline)
                        .padding()
                    Text("Bedingung: \(weatherViewModel.condition)")
                        .font(.subheadline)
                        .padding()
                }

                List {
                    Text("Aufgabe 1")
                    Text("Aufgabe 2")
                    Text("Aufgabe 3")
                }
                .listStyle(.insetGrouped)
            }
            .navigationTitle("Aufgaben")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {}) {
                        Image(systemName: "plus")
                    }
                }
            }
            .alert(item: $weatherViewModel.appError) { appError in
                Alert(title: Text("Fehler"), message: Text(appError.errorString), dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
