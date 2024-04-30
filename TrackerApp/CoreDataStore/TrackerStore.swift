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
    case decodingErrorInvalidCategory
    case fetchError
    case deletionError
    case pinError
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

protocol ContextMenuProtocol {
    func pinOrUnpinTracker(tracker: Tracker) throws
    func updateTracker(tracker: Tracker, with trackerObject: Tracker.TrackerObject) throws
    func deleteTracker(tracker: Tracker) throws
}

final class TrackerStore: NSObject {
    
    weak var delegate: TrackerStoreDelegate?
    
    private let context: NSManagedObjectContext
    private let trackerCategoryStore = TrackerCategoryStore()
    private let dateFormatter = DateFormatter()
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "category.creationDate", ascending: true),
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
        
        let tracker = fetchedResultsController.fetchedObjects?.first
        guard let tracker else { throw TrackerStoreError.fetchError }
        
        fetchedResultsController.fetchRequest.predicate = nil
        try fetchedResultsController.performFetch()
        
        return tracker
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
        
        guard let categoryObject = trackerCoreData.category,
              let category = try? trackerCategoryStore.category(from: categoryObject)
        else {
            throw TrackerStoreError.decodingErrorInvalidCategory
        }
        
        let isPinned = trackerCoreData.isPinned
        
        return Tracker(id: id,
                       name: name,
                       emoji: emoji,
                       color: UIColorMarshalling.color(from: colorHex),
                       schedule: Weekday.decodeWeekdays(from: trackerCoreData.schedule),
                       daysCompleted: daysCompleted,
                       category: category,
                       isPinned: isPinned)
    }
    
    func loadTrackersForDate(_ date: Date, searchText: String) throws {
        let weekdayAbbreviation = dateFormatter.string(from: date)
        
        var predicates: [NSPredicate] = []
        predicates.append(NSPredicate(
            format: "%K == nil OR (%K != nil AND %K CONTAINS[c] %@)",
            #keyPath(TrackerCoreData.schedule),
            #keyPath(TrackerCoreData.schedule),
            #keyPath(TrackerCoreData.schedule),
            weekdayAbbreviation
        ))
        
        if !searchText.isEmpty {
            predicates.append(NSPredicate(format: "%K contains[c] %@",
                                          #keyPath(TrackerCoreData.name),
                                          searchText))
        }
        
        fetchedResultsController.fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        try fetchedResultsController.performFetch()
        
        delegate?.didUpdateTrackers()
    }
}

extension TrackerStore: TrackerStoreProtocol {
    var numberOfSections: Int { return organizedTrackers.count }
    
    var numberOfTrackers: Int { return fetchedResultsController.fetchedObjects?.count ?? 0 }
    
    func numberOfRowsInSection(_ section: Int) -> Int { return organizedTrackers[section].count }
    
    func object(at indexPath: IndexPath) -> Tracker? { return organizedTrackers[indexPath.section][indexPath.row] }
    
    private var pinnedTrackers: [Tracker] {
        guard let fetchedObjects = fetchedResultsController.fetchedObjects else { return [] }
        
        return fetchedObjects.compactMap { object -> Tracker? in
            guard let tracker = try? tracker(from: object), tracker.isPinned else {
                return nil
            }
            return tracker
        }
    }
    
    private var organizedTrackers: [[Tracker]] {
        guard let trackerSections = fetchedResultsController.sections else { return [] }
        
        var allTrackerSections: [[Tracker]] = []
        
        if !pinnedTrackers.isEmpty {
            allTrackerSections.append(pinnedTrackers)
        }
        
        trackerSections.forEach { coreDataSection in
            let trackersForSection = coreDataSection.objects?.compactMap { object -> Tracker? in
                guard let trackerEntity = object as? TrackerCoreData,
                      let tracker = try? tracker(from: trackerEntity),
                      !pinnedTrackers.contains(where: { $0.id == tracker.id })
                else {
                    return nil
                }
                return tracker
            } ?? []
            
            if !trackersForSection.isEmpty {
                allTrackerSections.append(trackersForSection)
            }
        }
        
        return allTrackerSections
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
        trackerCoreData.isPinned = tracker.isPinned
        
        try context.save()
    }
    
    func headerForSection(_ section: Int) -> String? {
        if section == 0 && !pinnedTrackers.isEmpty {
            return NSLocalizedString("mainScreen.pinned", comment: "")
        }
        
        guard let categoryTitle = organizedTrackers[section].first?.category.title else {
            return nil
        }
        
        return categoryTitle
    }
}

extension TrackerStore: ContextMenuProtocol {
    func pinOrUnpinTracker(tracker: Tracker) throws {
        guard let trackerEntity = try findTrackerObjectByID(tracker.id) else {
            throw TrackerStoreError.pinError
        }
        
        trackerEntity.isPinned.toggle()
        
        try context.save()
    }

    func updateTracker(tracker: Tracker, with trackerObject: Tracker.TrackerObject) throws {
        guard let newEmoji = trackerObject.emoji,
              let newColor = trackerObject.color,
              let newCategory = trackerObject.category 
        else { return }

        guard let trackerEntity = try findTrackerObjectByID(tracker.id) else { return }
        let categoryEntity = try trackerCategoryStore.findCategoryObjectByID(newCategory.id)
        
        trackerEntity.name = trackerObject.name
        trackerEntity.emoji = newEmoji
        trackerEntity.colorHex = UIColorMarshalling.hexString(from: newColor)
        trackerEntity.schedule = Weekday.encodeWeekdays(trackerObject.schedule)
        trackerEntity.category = categoryEntity
        
        try context.save()
    }
    
    func deleteTracker(tracker: Tracker) throws {
        guard let trackerEntity = try findTrackerObjectByID(tracker.id) else {
            throw TrackerStoreError.deletionError
        }
        
        context.delete(trackerEntity)
        
        try context.save()
    }
}

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdateTrackers()
    }
}
