//
//  ProfileViewModel.swift
//  DVTWeatherApp
//
//  Created by Katherine Chambers on 2024/06/13.
//

import SwiftUI

protocol ProfileViewModelType: ObservableObject {
    
}

class ProfileViewModel: ObservableObject, ProfileViewModelType {
    
    let services: Services
    
    weak var coordinator: ProfileCoordinator?
    
    init(services: Services, coordinator: ProfileCoordinator? = nil) {
        self.services = services
        self.coordinator = coordinator
    }
}

