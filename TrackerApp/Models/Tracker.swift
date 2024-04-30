//
//  Tracker.swift
//  TrackerApp
//
//  Created by Vlad Vintenbakh on 15/3/24.
//

import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let emoji: String
    let color: UIColor
    let schedule: [Weekday]?
    let daysCompleted: Int
    let category: TrackerCategory
    let isPinned: Bool
    
    struct TrackerObject {
        var name: String = ""
        var emoji: String?
        var color: UIColor?
        var schedule: [Weekday]?
        var daysCompleted = 0
        var category: TrackerCategory?
        var isPinned: Bool = false
    }
    
    var trackerObjectInstance: TrackerObject {
        TrackerObject(name: name,
                      emoji: emoji,
                      color: color,
                      schedule: schedule,
                      daysCompleted: daysCompleted,
                      category: category,
                      isPinned: isPinned)
    }
}
