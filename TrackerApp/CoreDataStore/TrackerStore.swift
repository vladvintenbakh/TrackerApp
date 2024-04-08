//
//  TrackerStore.swift
//  TrackerApp
//
//  Created by Vlad Vintenbakh on 5/4/24.
//

import UIKit
import CoreData

enum TrackerStoreError: Error {
    case decodingErrorInvalidID
    case decodingErrorInvalidName
    case decodingErrorInvalidEmoji
    case decodingErrorInvalidColor
    case decodingErrorInvalidDaysCompleted
}

protocol TrackerStoreDelegate: AnyObject {
    func didUpdateTrackers()
}

protocol TrackerStoreProtocol {
    var numberOfSections: Int { get }
    var numberOfTrackers: Int { get }
    
    func numberOfRowsInSection(_ section: Int) -> Int
    func object(at indexPath: IndexPath) -> Tracker?
    func addTracker(category: TrackerCategory, tracker: Tracker) throws
    func headerForSection(_ section: Int) -> String?
}

final class TrackerStore: NSObject {
    
    weak var delegate: TrackerStoreDelegate?
    
    private let context: NSManagedObjectContext
    private let trackerCategoryStore = TrackerCategoryStore()
    private let dateFormatter = DateFormatter()
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "category.categoryID", ascending: true),
            NSSortDescriptor(key: "creationDate", ascending: true)
        ]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: context,
                                                                  sectionNameKeyPath: "category",
                                                                  cacheName: nil)
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()
    
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
        
        dateFormatter.dateFormat = "E"
        
        super.init()
    }
    
    func findTrackerObjectByID(_ id: UUID) throws -> TrackerCoreData? {
        fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "%K == %@",
                                                                      #keyPath(TrackerCoreData.trackerID),
                                                                      id.uuidString)
        try fetchedResultsController.performFetch()
        return fetchedResultsController.fetchedObjects?.first
    }
    
    func tracker(from trackerCoreData: TrackerCoreData) throws -> Tracker {
        guard let uuidString = trackerCoreData.trackerID,
              let id = UUID(uuidString: uuidString)
        else {
            throw TrackerStoreError.decodingErrorInvalidID
        }
        
        guard let name = trackerCoreData.name else {
            throw TrackerStoreError.decodingErrorInvalidName
        }
        
        guard let emoji = trackerCoreData.emoji else {
            throw TrackerStoreError.decodingErrorInvalidEmoji
        }
        
        guard let colorHex = trackerCoreData.colorHex else {
            throw TrackerStoreError.decodingErrorInvalidColor
        }
        
        guard let daysCompleted = trackerCoreData.records?.count else {
            throw TrackerStoreError.decodingErrorInvalidDaysCompleted
        }
        
        return Tracker(id: id,
                       name: name,
                       emoji: emoji,
                       color: UIColorMarshalling.color(from: colorHex),
                       schedule: Weekday.decodeWeekdays(from: trackerCoreData.schedule),
                       daysCompleted: daysCompleted)
    }
    
    func loadTrackersForDate(_ date: Date) throws {
        let weekdayAbbreviation = dateFormatter.string(from: date)
        
        var predicates: [NSPredicate] = []
        predicates.append(NSPredicate(
            format: "%K == nil OR (%K != nil AND %K CONTAINS[c] %@)",
            #keyPath(TrackerCoreData.schedule),
            #keyPath(TrackerCoreData.schedule),
            #keyPath(TrackerCoreData.schedule),
            weekdayAbbreviation
        ))
        
        fetchedResultsController.fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        try fetchedResultsController.performFetch()
        
        delegate?.didUpdateTrackers()
    }
}

extension TrackerStore: TrackerStoreProtocol {
    var numberOfSections: Int {
        fetchedResultsController.sections?.count ?? 0
    }
    
    var numberOfTrackers: Int {
        fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func object(at indexPath: IndexPath) -> Tracker? {
        let trackerCoreData = fetchedResultsController.object(at: indexPath)
        let tracker = try? tracker(from: trackerCoreData)
        return tracker ?? nil
    }
    
    func addTracker(category: TrackerCategory, tracker: Tracker) throws {
        let trackerCoreData = TrackerCoreData(context: context)
        
        trackerCoreData.trackerID = tracker.id.uuidString
        trackerCoreData.name = tracker.name
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.colorHex = UIColorMarshalling.hexString(from: tracker.color)
        trackerCoreData.schedule = Weekday.encodeWeekdays(tracker.schedule)
        
        trackerCoreData.creationDate = Date()
        trackerCoreData.category = try trackerCategoryStore.findCategoryObjectByID(category.id)
        
        try context.save()
    }
    
    func headerForSection(_ section: Int) -> String? {
        let trackerCoreData = fetchedResultsController.sections?[section].objects?.first as? TrackerCoreData
        guard let trackerCoreData else { return nil }
        
        let categoryHeader = trackerCoreData.category?.title
        return categoryHeader
    }
}

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdateTrackers()
    }
}
