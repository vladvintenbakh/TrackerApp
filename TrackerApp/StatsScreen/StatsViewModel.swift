//
//  StatsViewModel.swift
//  TrackerApp
//
//  Created by Vlad Vintenbakh on 26/4/24.
//

import Foundation

final class StatsViewModel {
    
    var onRecordsUpdateStateChange: Binding<[TrackerRecord]>?
    
    private var records: [TrackerRecord] = [] {
        didSet {
            onRecordsUpdateStateChange?(records)
        }
    }
    
    private let trackerRecordStore = TrackerRecordStore()
    
    func viewWillAppear() {
        let records = try? trackerRecordStore.fetchAll()
        guard let records else { return }
        self.records = records
    }
}
