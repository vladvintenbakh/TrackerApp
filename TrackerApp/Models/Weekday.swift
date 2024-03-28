//
//  Weekday.swift
//  TrackerApp
//
//  Created by Vlad Vintenbakh on 24/3/24.
//

import Foundation

enum Weekday: String, CaseIterable, Comparable {
    case mon = "Monday"
    case tue = "Tuesday"
    case wed = "Wednesday"
    case thu = "Thursday"
    case fri = "Friday"
    case sat = "Saturday"
    case sun = "Sunday"
}

extension Weekday {
    static func < (lhs: Weekday, rhs: Weekday) -> Bool {
        guard let lhsIndex = allCases.firstIndex(of: lhs),
              let rhsIndex = allCases.firstIndex(of: rhs) else {
            return false
        }
        return lhsIndex < rhsIndex
    }
}
