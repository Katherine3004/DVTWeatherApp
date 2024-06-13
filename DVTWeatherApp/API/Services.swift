//
//  Services.swift
//  DVTWeatherApp
//
//  Created by Katherine Chambers on 2024/06/13.
//

import Foundation

class Services: ObservableObject {
    
    let weatherService: WeatherService
    
    init() {
        self.weatherService = WeatherAPI()
    }
}
