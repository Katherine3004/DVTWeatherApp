//
//  HomeCoordinator.swift
//  DVTWeatherApp
//
//  Created by Katherine Chambers on 2024/06/13.
//

import SwiftUI
import UIKit
import Foundation

class HomeCoordinator: NSObject, Coordinator, UINavigationControllerDelegate, ObservableObject {
    
    private let services: Services
    private let locationManager: LocationManager
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController, services: Services) {
        self.navigationController = navigationController
        self.services = services
        self.locationManager = LocationManager()
    }
    
    func start() {
        navigationController.delegate = self
        let vm = HomeViewModel(services: services, locationManager: locationManager, coordinator: self)
        let vc = UIHostingController(rootView: HomeView(vm:vm))
        vc.tabBarItem = UITabBarItem(title: "Home",
                                     image: UIImage(systemName: "house"),
                                     selectedImage: UIImage(systemName: "house.fill"))
        navigationController.pushViewController(vc, animated: false)
    }
    
    func popView() {
        navigationController.dismiss(animated: true, completion: nil)
    }
    
    func dismissView() {
        navigationController.dismiss(animated: true, completion: nil)
    }
}

