//
//  TrackerCategory.swift
//  TrackerApp
//
//  Created by Vlad Vintenbakh on 15/3/24.
//

import Foundation

struct TrackerCategory {
    let title: String
    let trackers: [Tracker]
    
    static let defaultCategories: [TrackerCategory] = [
        TrackerCategory(title: "Default 1", trackers: []),
        TrackerCategory(title: "Default 2", trackers: []),
        TrackerCategory(title: "Default 3", trackers: [])
    ]
}
