//
//  TabBarController.swift
//  TrackerApp
//
//  Created by Vlad Vintenbakh on 10/3/24.
//

import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        tabBar.layer.borderWidth = 1
        tabBar.layer.borderColor = UIColor(named: "YPGray")?.cgColor
        
        let trackersVC = TrackersViewController()
        let navigationVC = UINavigationController(rootViewController: trackersVC)
        let firstVC = navigationVC
        let firstVCTitle = NSLocalizedString("shared.trackerTabTitle", comment: "")
        firstVC.tabBarItem = UITabBarItem(title: firstVCTitle,
                                          image: UIImage(named: "TrackersTabBarIcon"),
                                          tag: 0)
        
        let secondVC = StatsViewController()
        let secondVCTitle = NSLocalizedString("mainScreen.tabBarItemTwo", comment: "")
        secondVC.tabBarItem = UITabBarItem(title: secondVCTitle,
                                           image: UIImage(named: "StatsTabBarIcon"),
                                           tag: 1)
        
        self.viewControllers = [firstVC, secondVC]
    }
}
