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
    case error
}

protocol HomeViewModelType: ObservableObject {
    var state: HomeViewState { get set }
    var weather: Weather? { get set }
    var forecast: Forecast? { get set }
    
    func fetachWeather()
    func fetchForecase()
}

class HomeViewModel: ObservableObject,  HomeViewModelType {
    
    @Published var state: HomeViewState = .loading
    @Published var weather: Weather?
    @Published var forecast: Forecast?
    
    let services: Services
    
    weak var coordinator: HomeCoordinator?
    
    init(services: Services, coordinator: HomeCoordinator? = nil) {
        self.services = services
        self.coordinator = coordinator
        
        fetachWeather()
        fetchForecase()
    }
    
    func fetachWeather() {
        Task {
            do {
                let response = try await services.weatherService.fetchWeather(lat: "-29.85", long: "31.02")
                
                await MainActor.run {
                    self.weather = response
                }
            }
            catch {
                print("DEBUG func fetachWeather(): Error \(error)")
            }
        }
    }
    
    func fetchForecase() {
        Task {
            do {
                let response = try await services.weatherService.fetchForecast(lat: "-29.85", long: "31.02")
                
                await MainActor.run {
                    self.forecast = response
                }
            }
            catch {
                print("DEBUG func fetchForecase(): Error \(error)")
            }
        }
    }
}

class HomeViewModelPreview: ObservableObject,  HomeViewModelType {
    
    @Published var state: HomeViewState = .loading
    var weather: Weather?
    @Published var forecast: Forecast?
    
    init(weather: Weather?) {
        self.weather = weather
    }
    
    func fetachWeather() {}
    func fetchForecase() {}
}
