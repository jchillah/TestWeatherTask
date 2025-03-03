//
//  LocationServiceProtocol.swift
//  WeatherTask
//
//  Created by Michael Winkler on 03.03.25.
//


import CoreLocation
import Foundation

protocol LocationServiceProtocol {
    func getCurrentLocation() async throws -> CLLocationCoordinate2D
}

final class LocationService: NSObject, CLLocationManagerDelegate, LocationServiceProtocol {
    private let locationManager = CLLocationManager()
    private var locationContinuation: CheckedContinuation<CLLocationCoordinate2D, Error>?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func getCurrentLocation() async throws -> CLLocationCoordinate2D {
        return try await withCheckedThrowingContinuation { continuation in
            locationContinuation = continuation
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            locationContinuation?.resume(returning: location.coordinate)
            locationContinuation = nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationContinuation?.resume(throwing: error)
        locationContinuation = nil
    }
}
