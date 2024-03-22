//
//  Tracker.swift
//  TrackerApp
//
//  Created by Vlad Vintenbakh on 15/3/24.
//

import UIKit

enum Weekday: String {
    case mon = "Monday"
    case tue = "Tuesday"
    case wed = "Wednesday"
    case thu = "Thursday"
    case fri = "Friday"
    case sat = "Saturday"
    case sun = "Sunday"
}

struct Tracker {
    let id: UUID
    let name: String
    let emoji: String
    let color: UIColor
    let schedule: [Weekday]?
    
    struct TrackerObject {
        var name: String = ""
        var emoji: String?
        var color: UIColor?
        var schedule: [Weekday]?
    }
}
