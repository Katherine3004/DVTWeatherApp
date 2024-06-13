//
//  ProfileCoordinator.swift
//  DVTWeatherApp
//
//  Created by Katherine Chambers on 2024/06/13.
//

import SwiftUI
import UIKit
import Foundation

class ProfileCoordinator: NSObject, Coordinator, UINavigationControllerDelegate, ObservableObject {
    
    private let services: Services
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController, services: Services) {
        self.navigationController = navigationController
        self.services = services
    }
    
    func start() {
        navigationController.delegate = self
        let vm = ProfileViewModel(services: services, coordinator: self)
        let vc = UIHostingController(rootView: ProfileView(vm: vm))
        vc.tabBarItem = UITabBarItem(title: "Profile",
                                     image: UIImage(systemName: "person"),
                                     selectedImage: UIImage(systemName: "person.fill"))
        navigationController.pushViewController(vc, animated: false)
    }
    
    func popView() {
        navigationController.dismiss(animated: true, completion: nil)
    }
    
    func dismissView() {
        navigationController.dismiss(animated: true, completion: nil)
    }
}
