//
//  TrackerCategory.swift
//  TrackerApp
//
//  Created by Vlad Vintenbakh on 15/3/24.
//

import Foundation

struct TrackerCategory: Equatable {
    let id: UUID
    let title: String
    
    struct CategoryObject {
        let id: UUID
        var title: String
    }
}
