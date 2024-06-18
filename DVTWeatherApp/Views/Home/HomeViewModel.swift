//
//  HomeViewModel.swift
//  DVTWeatherApp
//
//  Created by Katherine Chambers on 2024/06/13.
//

import SwiftUI

enum HomeViewState {
    case loading
    case loaded
    case error(title: String, message: String)
}

protocol HomeViewModelType: ObservableObject {
    var state: HomeViewState { get set }
    
    var weather: Weather? { get set }
    var forecast: Forecast? { get set }
    
    var showLocationPermissionSheet: Bool { get set }
    
    func load()
}

class HomeViewModel: ObservableObject,  HomeViewModelType {
    
    @Published var state: HomeViewState = .loading
    @Published var weather: Weather?
    @Published var forecast: Forecast?
    
    @Published var showLocationPermissionSheet: Bool = false
    
    let services: Services
    let locationManager: LocationManager
    
    var lat: String = ""
    var long: String = ""
    
    weak var coordinator: HomeCoordinator?
    
    init(services: Services, locationManager: LocationManager, coordinator: HomeCoordinator? = nil) {
        self.services = services
        self.locationManager = locationManager
        self.coordinator = coordinator
        
        load()
    }
    
    func load() {
        Task {
            await updateState(state: .loading)
            await checkLocationPermission()
            await getCurrentLocation()
            await getWeather()
        }
    }
    
    func getWeather() async {
        do {
            await updateState(state: .loading)
            let weatherResponse = try await services.weatherService.fetchWeather(lat: lat, long: long)
            let forecastResponse = try await services.weatherService.fetchForecast(lat: lat, long: long)
            
            await MainActor.run {
                self.weather = weatherResponse
                self.forecast = forecastResponse
            }
            
            await updateState(state: .loaded)
        }
        catch {
            await updateState(state: .error(title: "Loading Error", message: error.localizedDescription))
        }
        
    }
    
    func checkLocationPermission() async {
        let status = locationManager.locationStatus
        
        switch status {
        case .notDetermined:
            LocationManager.shared.requestAuthorisation()
        case .denied, .restricted:
            showLocationPermissionSheet = true
        case .authorizedAlways, .authorizedWhenInUse:
            await getCurrentLocation()
        default: break
        }
    }
    
    func getCurrentLocation() async {
        do {
            let location = try await LocationManager.shared.getCurrentLocation()
            
            await MainActor.run {
                self.lat = String(format: "%.2f", location.coordinate.latitude)
                self.long = String(format: "%.2f", location.coordinate.longitude)
            }
        }
        catch {
            await updateState(state: .error(title: "Location Error", message: "We could not find users location"))
        }
    }
    
    @MainActor
    private func updateState(state: HomeViewState) {
        withAnimation(.easeInOut(duration: 0.25)) {
            self.state = state
        }
    }
}

class HomeViewModelPreview: ObservableObject,  HomeViewModelType {
    
    @Published var state: HomeViewState = .loading
    @Published var weather: Weather?
    @Published var forecast: Forecast?
    
    @Published var showLocationPermissionSheet: Bool = false
    
    init() {
    }
    
    func load() {}
}
