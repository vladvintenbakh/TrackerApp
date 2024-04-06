//
//  TrackerRecord.swift
//  TrackerApp
//
//  Created by Vlad Vintenbakh on 15/3/24.
//

import Foundation

struct TrackerRecord: Hashable {
    let id: UUID
    let trackerID: UUID
    let date: Date
}
