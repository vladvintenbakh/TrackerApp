//
//  Date+safeDate.swift
//  TrackerApp
//
//  Created by Vlad Vintenbakh on 5/4/24.
//

import Foundation

extension Date {
    static func safeDate(_ date: Date) -> Date? {
        let calendar = Calendar(identifier: .gregorian)
        let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        
        guard
            let year = components.year,
            let month = components.month,
            let day = components.day
        else { return nil }
        
        let safeComponents = DateComponents(year: year, month: month, day: day)
        let safeDate = calendar.date(from: safeComponents)
        
        return safeDate
    }
}
