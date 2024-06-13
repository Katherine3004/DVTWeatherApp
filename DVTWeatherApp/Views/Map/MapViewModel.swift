//
//  MapViewModel.swift
//  DVTWeatherApp
//
//  Created by Katherine Chambers on 2024/06/13.
//

import SwiftUI

protocol MapViewModelType: ObservableObject {
    
}

class MapViewModel: ObservableObject, MapViewModelType {
    
    let services: Services
    
    weak var coordinator: MapCoordinator?
    
    init(services: Services, coordinator: MapCoordinator? = nil) {
        self.services = services
        self.coordinator = coordinator
    }
}
