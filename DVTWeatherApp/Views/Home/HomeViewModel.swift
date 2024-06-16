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
    
    func fetachWeather(lat: String, long: String)
}

class HomeViewModel: ObservableObject,  HomeViewModelType {
    
    @Published var state: HomeViewState = .loading
    @Published var weather: Weather?
    
    let services: Services
    
    weak var coordinator: HomeCoordinator?
    
    init(services: Services, coordinator: HomeCoordinator? = nil) {
        self.services = services
        self.coordinator = coordinator
    }
    
    func fetachWeather(lat: String, long: String) {
        Task {
            do {
                let response = try await services.weatherService.fetchWeather(lat: "-29.85", long: "31.02")
                
                await MainActor.run {
                    self.weather = response
                }
            }
            catch {
                print("DEBUG func fetachWeather(lat: Double, lon: Double): Error \(error)")
            }
        }
    }
}

class HomeViewModelPreview: ObservableObject,  HomeViewModelType {
    
    @Published var state: HomeViewState = .loading
    var weather: Weather?
    
    init(weather: Weather?) {
        self.weather = weather
    }
    
    func fetachWeather(lat: String, long: String) {}
}
