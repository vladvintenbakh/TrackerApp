//
//  TrackerCategoryStore.swift
//  TrackerApp
//
//  Created by Vlad Vintenbakh on 5/4/24.
//

import UIKit
import CoreData

enum TrackerCategoryStoreError: Error {
    case decodingErrorInvalidID
    case decodingErrorInvalidTitle
    case failedToFetch
}

enum CategoryError: Error {
    case categoryNotFound
}

protocol TrackerCategoryStoreDelegate: AnyObject {
    func didUpdateCategories()
}

final class TrackerCategoryStore: NSObject {
    
    weak var delegate: TrackerCategoryStoreDelegate?
    
    private let context: NSManagedObjectContext
    
    var fetchedCategoryObjectList: [TrackerCategoryCoreData] { fetchedResultsController.fetchedObjects ?? [] }
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData> = {
        let fetchRequest = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: true)
        ]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: context,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()
    
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        try! self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()
    }
    
    func addCategoryToCoreData(_ category: TrackerCategory) throws {
        
        let categoryCoreData = TrackerCategoryCoreData(context: context)
        
        categoryCoreData.categoryID = category.id.uuidString
        categoryCoreData.title = category.title
        categoryCoreData.creationDate = Date()
        
        try context.save()
    }
    
    func findCategoryObjectByID(_ id: UUID) throws -> TrackerCategoryCoreData {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.predicate = NSPredicate(format: "%K == %@", 
                                        #keyPath(TrackerCategoryCoreData.categoryID),
                                        id.uuidString)
        
        let categoryList = try context.fetch(request)
        guard let category = categoryList.first else {
            throw CategoryError.categoryNotFound
        }
        
        return category
    }
    
    private func getFetchedObjectByID(_ id: UUID) throws -> TrackerCategoryCoreData {
        fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "%K == %@",
                                                                      #keyPath(TrackerCategoryCoreData.categoryID),
                                                                      id.uuidString)

        try fetchedResultsController.performFetch()
        
        guard let category = fetchedResultsController.fetchedObjects?.first else {
            throw TrackerCategoryStoreError.failedToFetch
        }
        
        fetchedResultsController.fetchRequest.predicate = nil
        try fetchedResultsController.performFetch()
        
        return category
    }
    
    func category(from categoryCoreData: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard let uuidString = categoryCoreData.categoryID,
              let id = UUID(uuidString: uuidString)
        else {
            throw TrackerCategoryStoreError.decodingErrorInvalidID
        }
        
        guard let title = categoryCoreData.title else {
            throw TrackerCategoryStoreError.decodingErrorInvalidTitle
        }
        
        return TrackerCategory(id: id, title: title)
    }
    
    func editCategoryObject(newCategoryObject: TrackerCategory.CategoryObject) throws {
        let category = try getFetchedObjectByID(newCategoryObject.id)
        category.title = newCategoryObject.title
        
        try context.save()
    }
    
    func deleteCategoryObject(categoryObject: TrackerCategory) throws {
        let category = try getFetchedObjectByID(categoryObject.id)
        context.delete(category)
        
        try context.save()
    }
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdateCategories()
    }
}
