//
//  HomeViewModel.swift
//  DVTWeatherApp
//
//  Created by Katherine Chambers on 2024/06/13.
//

import SwiftUI

enum HomeViewState {
    case loading
    case loaded(weather: Weather, forecast: Forecast)
}

protocol HomeViewModelType: ObservableObject {
    var state: HomeViewState { get set }
    
    //error
    var showErrorDialog: Bool { get set }
    var errorMessage: String { get set }
    var errorTitle: String { get set }
    
    func load()
}

class HomeViewModel: ObservableObject,  HomeViewModelType {
    
    @Published var state: HomeViewState = .loading
    
    //error
    var showErrorDialog: Bool = false
    var errorMessage: String = ""
    var errorTitle: String = ""
    
    let services: Services
    
    weak var coordinator: HomeCoordinator?
    
    init(services: Services, coordinator: HomeCoordinator? = nil) {
        self.services = services
        self.coordinator = coordinator
    }
    
    func load() {
        self.state = .loading
        Task {
            do {
                let weatherResponse = try await services.weatherService.fetchWeather(lat: "-29.85", long: "31.02")
                let forecastResponse = try await services.weatherService.fetchForecast(lat: "-29.85", long: "31.02")
                
                await updateState(state: .loaded(weather: weatherResponse, forecast: forecastResponse))
            }
            catch {
                
                await updateErrorDialog(show: true, title: "Loading Error", message: error.localizedDescription)
            }
        }
    }
    
    @MainActor
    private func updateState(state: HomeViewState) {
        withAnimation(.easeInOut(duration: 0.25)) {
            self.state = state
        }
    }
    
    @MainActor
    private func updateErrorDialog(show: Bool, title: String, message: String) {
        withAnimation(.easeInOut(duration: 0.25)) {
            self.showErrorDialog = show
            self.errorTitle = title
            self.errorMessage = message
        }
    }
}

class HomeViewModelPreview: ObservableObject,  HomeViewModelType {
    
    @Published var state: HomeViewState = .loading
    
    //error
    var showErrorDialog: Bool = false
    var errorMessage: String = ""
    var errorTitle: String = ""
    
    init() {
        
    }
    
    func load() {}
}
