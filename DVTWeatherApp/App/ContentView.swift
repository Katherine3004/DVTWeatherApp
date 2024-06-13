//
//  ContentView.swift
//  DVTWeatherApp
//
//  Created by Katherine Chambers on 2024/06/13.
//

import SwiftUI

struct ContentView: View {
    
    private let services: Services
    
    init() {
        self.services = Services()
    }
    
    var body: some View {
        AppTabController(services: services)
            .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
