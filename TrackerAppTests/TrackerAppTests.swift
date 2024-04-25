//
//  TrackerAppTests.swift
//  TrackerAppTests
//
//  Created by Vlad Vintenbakh on 25/4/24.
//

import XCTest
import SnapshotTesting
@testable import TrackerApp

final class TrackerAppTests: XCTestCase {
    func testMainScreen() {
        let vc = TabBarController()
        assertSnapshot(matching: vc, as: .image)
    }
}
