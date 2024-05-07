//
//  TabBarController.swift
//  TrackerApp
//
//  Created by Vlad Vintenbakh on 10/3/24.
//

import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        tabBar.layer.borderWidth = 0.5
        updateBorderColor(for: traitCollection)
        
        let trackersVC = TrackersViewController()
        let navigationVC = UINavigationController(rootViewController: trackersVC)
        let firstVC = navigationVC
        let firstVCTitle = NSLocalizedString("shared.trackerTabTitle", comment: "")
        firstVC.tabBarItem = UITabBarItem(title: firstVCTitle,
                                          image: UIImage(named: "TrackersTabBarIcon"),
                                          tag: 0)
        
        let secondVC = StatsViewController(viewModel: StatsViewModel())
        let secondVCTitle = NSLocalizedString("mainScreen.tabBarItemTwo", comment: "")
        secondVC.tabBarItem = UITabBarItem(title: secondVCTitle,
                                           image: UIImage(named: "StatsTabBarIcon"),
                                           tag: 1)
        
        self.viewControllers = [firstVC, secondVC]
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateBorderColor(for: traitCollection)
        }
    }
    
    private func updateBorderColor(for traitCollection: UITraitCollection) {
        if traitCollection.userInterfaceStyle == .dark {
            tabBar.layer.borderColor = UIColor.black.cgColor
        } else {
            tabBar.layer.borderColor = UIColor(named: "YPGray")?.cgColor
        }
    }
}
