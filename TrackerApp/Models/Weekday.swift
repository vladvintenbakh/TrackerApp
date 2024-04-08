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
    func abbreviation() -> String {
        switch self {
        case .mon: return "Mon"
        case .tue: return "Tue"
        case .wed: return "Wed"
        case .thu: return "Thu"
        case .fri: return "Fri"
        case .sat: return "Sat"
        case .sun: return "Sun"
        }
    }
    
    static func < (lhs: Weekday, rhs: Weekday) -> Bool {
        guard let lhsIndex = allCases.firstIndex(of: lhs),
              let rhsIndex = allCases.firstIndex(of: rhs) else {
            return false
        }
        return lhsIndex < rhsIndex
    }
    
    static func encodeWeekdays(_ weekdays: [Weekday]?) -> String? {
        guard let weekdays else { return nil }
        return weekdays.map { $0.abbreviation() }.joined(separator: ", ")
    }
    
    static func decodeWeekdays(from string: String?) -> [Weekday]? {
        guard let string else { return nil }
        
        let abbreviations = string.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        
        var weekdays: [Weekday] = []
        for abbreviation in abbreviations {
            if let weekday = Weekday(from: abbreviation) {
                weekdays.append(weekday)
            }
        }
        
        return weekdays.isEmpty ? nil : weekdays
    }
    
    init?(from abbreviation: String) {
        switch abbreviation {
        case "Mon": self = .mon
        case "Tue": self = .tue
        case "Wed": self = .wed
        case "Thu": self = .thu
        case "Fri": self = .fri
        case "Sat": self = .sat
        case "Sun": self = .sun
        default: return nil
        }
    }
}
