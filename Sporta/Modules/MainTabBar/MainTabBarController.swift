//
//  MainTabBarController.swift
//  Sporta
//
//  Created by Mohamed Ayman on 07/05/2026.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    private let logoOrange = UIColor(red: 255/255, green: 126/255, blue: 33/255, alpha: 1.0)
    private let logoNavy   = UIColor(red: 20/255,  green: 40/255,  blue: 80/255,  alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyAppearance()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        applyAppearance()
    }
    
    private func applyAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        
        appearance.stackedLayoutAppearance.selected.iconColor = logoOrange
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: logoOrange
        ]
        
        appearance.stackedLayoutAppearance.normal.iconColor = logoNavy
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: logoNavy
        ]
        
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
        
        tabBar.tintColor = logoOrange
        tabBar.unselectedItemTintColor = logoNavy
    }
}
