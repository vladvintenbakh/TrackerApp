//
//  TabBarController.swift
//  TrackerApp
//
//  Created by Vlad Vintenbakh on 10/3/24.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        let trackersVC = TrackersViewController()
        let navigationVC = UINavigationController(rootViewController: trackersVC)
        let firstVC = navigationVC
        firstVC.tabBarItem = UITabBarItem(title: "Trackers",
                                          image: UIImage(named: "TrackersTabBarIcon"),
                                          tag: 0)
        
        let secondVC = StatsViewController()
        secondVC.tabBarItem = UITabBarItem(title: "Statistics",
                                           image: UIImage(named: "StatsTabBarIcon"),
                                           tag: 1)
        
        self.viewControllers = [firstVC, secondVC]
    }
}
