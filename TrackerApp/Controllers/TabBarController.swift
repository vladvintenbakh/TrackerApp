//
//  TabBarController.swift
//  TrackerApp
//
//  Created by Vlad Vintenbakh on 10/3/24.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        let firstVC = TrackersViewController()
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
