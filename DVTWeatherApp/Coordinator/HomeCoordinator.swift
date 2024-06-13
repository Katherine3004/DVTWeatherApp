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
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController, services: Services) {
        self.navigationController = navigationController
        self.services = services
    }
    
    func start() {
        navigationController.delegate = self
        let vm = HomeViewModel(services: services, coordinator: self)
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

