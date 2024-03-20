//
//  GeometricParams.swift
//  TrackerApp
//
//  Created by Vlad Vintenbakh on 20/3/24.
//

import Foundation

struct GeometricParams {
    let cellCount: Int
    let leftInset: CGFloat
    let rightInset: CGFloat
    let cellSpacing: CGFloat
    let paddingWidth: CGFloat
    let topInset: CGFloat
    let bottomInset: CGFloat
    
    init(cellCount: Int, 
         leftInset: CGFloat,
         rightInset: CGFloat,
         cellSpacing: CGFloat,
         topInset: CGFloat,
         bottomInset: CGFloat) {
        self.cellCount = cellCount
        self.leftInset = leftInset
        self.rightInset = rightInset
        self.cellSpacing = cellSpacing
        self.paddingWidth = leftInset + rightInset + CGFloat(cellCount - 1) * cellSpacing
        self.topInset = topInset
        self.bottomInset = bottomInset
    }
}
