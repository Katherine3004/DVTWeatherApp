//
//  LocationManager.swift
//  DVTWeatherApp
//
//  Created by Katherine Chambers on 2024/06/17.
//

import Foundation
import SwiftUI
import CoreLocation

class LocationManager: NSObject, ObservableObject {
    
    static let shared = LocationManager()
    var userCanSeeLocationNotificationAgain = true
    var locationStatus: CLAuthorizationStatus?
    
    private let locationManager = CLLocationManager()
    private var completion: ((Result<CLLocation, Error>) -> Void)?
    private var numberOfLocationsFetched = 0
    private var lastLocation: (location: CLLocation, time: Date)?
    
    var hasCachedResult: Bool {
        if let lastLocation, intervalSince(lastLocation.time, isLessThan: 30) {
            return true
        }
        else {
            return false
        }
    }
    
    var cachedLocation: CLLocation? {
        return lastLocation?.location
    }
    
    var isLocationAuthorised: Bool {
        switch locationStatus {
        case .notDetermined, .restricted, .denied:
            return false
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        default: return false
        }
    }
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    public func requestAuthorisation() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    public func getCurrentLocation() async throws -> CLLocation {
        if let lastLocation, intervalSince(lastLocation.time, isLessThan: 30) {
            return lastLocation.location
        }
        
        numberOfLocationsFetched = 0
        locationManager.startUpdatingLocation()
        return try await withCheckedThrowingContinuation { continuation in
            getCurrentLocation { result in
                switch result {
                case .success(let location):
                    continuation.resume(returning: location)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    private func getCurrentLocation(completion: @escaping (Result<CLLocation, Error>) -> Void) {
        if let location = locationManager.location {
            lastLocation = (location: location, time: Date())
            completion(.success(location))
        } else {
            locationManager.requestLocation()
            self.completion = completion
        }
    }
    
    private func intervalSince(_ previous: Date, isLessThan minutes: Int) -> Bool {
        return Date() < previous.advanced(by: Double(minutes) * 60.0)
     }
}

extension LocationManager: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationStatus = status
        print(locationStatus)
        switch status {
        case .notDetermined:
            print("DEBUG: notDetermined")
        case .restricted:
            print("DEBUG: restricted")
        case .denied:
            print("DEBUG: denied")
        case .authorizedAlways:
            print("DEBUG: authorizedAlways")
        case .authorizedWhenInUse:
            print("DEBUG: authorizedWhenInUse")
        @unknown default:
            break
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            completion?(.failure(LocationError.noLocationAvailable))
            return
        }
        numberOfLocationsFetched += 1
        if numberOfLocationsFetched >= 5 {
            manager.stopUpdatingLocation()
            completion?(.success(location))
            completion = nil
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        completion?(.failure(error))
        completion = nil
    }
}

enum LocationError: Error {
    case noLocationAvailable
}
