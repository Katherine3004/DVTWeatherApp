//
//  HomeViewModel.swift
//  DVTWeatherApp
//
//  Created by Katherine Chambers on 2024/06/13.
//

import SwiftUI

protocol HomeViewModelType: ObservableObject {
    
}

class HomeViewModel: ObservableObject,  HomeViewModelType {
    
    let services: Services
    
    weak var coordinator: HomeCoordinator?
    
    init(services: Services, coordinator: HomeCoordinator? = nil) {
        self.services = services
        self.coordinator = coordinator
    }
}
