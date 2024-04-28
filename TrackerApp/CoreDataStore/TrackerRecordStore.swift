//
//  TrackerRecordStore.swift
//  TrackerApp
//
//  Created by Vlad Vintenbakh on 5/4/24.
//

import UIKit
import CoreData

enum TrackerRecordStoreError: Error {
    case decodingErrorInvalidID
    case decodingErrorInvalidDate
    case decodingErrorInvalidTracker
}

protocol TrackerRecordStoreDelegate: AnyObject {
    func didUpdateRecords(newRecordSet: Set<TrackerRecord>)
}

final class TrackerRecordStore: NSObject {
    
    weak var delegate: TrackerRecordStoreDelegate?
    
    private let context: NSManagedObjectContext
    private let trackerStore = TrackerStore()
    
    private var completedTrackers: Set<TrackerRecord> = []
    
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
    }
    
    func record(from recordCoreData: TrackerRecordCoreData) throws -> TrackerRecord {
        guard let uuidString = recordCoreData.recordID,
              let id = UUID(uuidString: uuidString)
        else {
            throw TrackerRecordStoreError.decodingErrorInvalidID
        }
        
        guard let date = recordCoreData.date else {
            throw TrackerRecordStoreError.decodingErrorInvalidDate
        }
        
        guard let trackerCoreData = recordCoreData.tracker,
              let tracker = try? trackerStore.tracker(from: trackerCoreData)
        else {
            throw TrackerRecordStoreError.decodingErrorInvalidTracker
        }
        
        return TrackerRecord(id: id, trackerID: tracker.id, date: date)
    }
    
    func addRecord(_ record: TrackerRecord) throws {
        let trackerCoreData = try trackerStore.findTrackerObjectByID(record.trackerID)
        
        let trackerRecordCoreData = TrackerRecordCoreData(context: context)
        trackerRecordCoreData.recordID = record.id.uuidString
        trackerRecordCoreData.date = record.date
        trackerRecordCoreData.tracker = trackerCoreData
        try context.save()
        
        completedTrackers.insert(record)
        delegate?.didUpdateRecords(newRecordSet: completedTrackers)
    }
    
    func deleteRecord(_ record: TrackerRecord) throws {
        let fetchRequest = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        fetchRequest.predicate = NSPredicate(format: "%K == %@",
                                             #keyPath(TrackerRecordCoreData.recordID),
                                             record.id.uuidString)
        
        let recordList = try context.fetch(fetchRequest)
        guard let recordToRemove = recordList.first else { return }
        context.delete(recordToRemove)
        try context.save()
        
        completedTrackers.remove(record)
        delegate?.didUpdateRecords(newRecordSet: completedTrackers)
    }
    
    func loadCompletedTrackersForDate(_ date: Date) throws {
        let fetchRequest = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        fetchRequest.returnsObjectsAsFaults = false
        
        fetchRequest.predicate = NSPredicate(format: "%K == %@", 
                                             #keyPath(TrackerRecordCoreData.date),
                                             date as NSDate)
        
        let transformedRecords = try context.fetch(fetchRequest).compactMap { try? record(from: $0) }
        
        completedTrackers = Set(transformedRecords)
        delegate?.didUpdateRecords(newRecordSet: completedTrackers)
    }
    
    func fetchAll() throws -> [TrackerRecord] {
        let fetchRequest = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        let records = try context.fetch(fetchRequest).map { try record(from: $0) }
        return records
    }
}
