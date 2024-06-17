//
//  AppTabController.swift
//  DVTWeatherApp
//
//  Created by Katherine Chambers on 2024/06/13.
//

import SwiftUI
import UIKit
import Combine

protocol TabIndexDelegate {
    func setTabIndex(index: Int)
}

struct AppTabController: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = TabController
    
    let services: Services
    
    func makeUIViewController(context: Context) -> TabController {
        TabController(services: services)
    }
    
    func updateUIViewController(_ uiViewController: TabController, context: Context) {
    }
}

class TabController: UITabBarController, TabIndexDelegate {
    
    let services: Services
    
    private let homeCoordinator: HomeCoordinator
    private let mapCoordinator: MapCoordinator
    private let profileCoordinator: ProfileCoordinator
    
    init(services: Services) {
        self.services = services
        
        self.mapCoordinator = MapCoordinator(navigationController: UINavigationController(), services: services)
        self.homeCoordinator = HomeCoordinator(navigationController: UINavigationController(), services: services)
        self.profileCoordinator = ProfileCoordinator(navigationController: UINavigationController(), services: services)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white

            setTabBarItemBadgeAppearance(appearance.stackedLayoutAppearance)
            setTabBarItemBadgeAppearance(appearance.inlineLayoutAppearance)
            setTabBarItemBadgeAppearance(appearance.compactInlineLayoutAppearance)
            
            self.tabBar.standardAppearance = appearance
            self.tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        }
        
        mapCoordinator.start()
        homeCoordinator.start()
        profileCoordinator.start()
        
        viewControllers = [homeCoordinator.navigationController,
                           mapCoordinator.navigationController,
                           profileCoordinator.navigationController]
    }
    
    private func setTabBarItemBadgeAppearance(_ itemAppearance: UITabBarItemAppearance) {
        itemAppearance.normal.badgeBackgroundColor = UIColor(hex: 0x93C6E7, alpha: 1)
        
        itemAppearance.selected.iconColor = .cloudy
        itemAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.cloudy]
        
    }
    
    func setTabIndex(index: Int) {
        self.selectedIndex = index
    }
    
}
