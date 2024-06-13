//
//  MapCoordinator.swift
//  DVTWeatherApp
//
//  Created by Katherine Chambers on 2024/06/13.
//

import SwiftUI
import UIKit
import Foundation

class MapCoordinator: NSObject, Coordinator, UINavigationControllerDelegate, ObservableObject {
    
    private let services: Services
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    
    init(navigationController: UINavigationController, services: Services) {
        self.navigationController = navigationController
        self.services = services
    }
    
    func start() {
        navigationController.delegate = self
        let vm = MapViewModel(services: services, coordinator: self)
        let vc = UIHostingController(rootView: MapView(vm: vm))
        vc.tabBarItem = UITabBarItem(title: "Map",
                                     image: UIImage(systemName: "map"),
                                     selectedImage: UIImage(systemName: "map.fill"))
        navigationController.pushViewController(vc, animated: false)
    }
    
    func popView() {
        navigationController.dismiss(animated: true, completion: nil)
    }
    
    func dismissView() {
        navigationController.dismiss(animated: true, completion: nil)
    }
}

