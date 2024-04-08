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
}

enum CategoryError: Error {
    case categoryNotFound
}

final class TrackerCategoryStore: NSObject {
    
    private let context: NSManagedObjectContext
    private let defaultCategories = [
        TrackerCategory(id: UUID(), title: "Default Category 1"),
        TrackerCategory(id: UUID(), title: "Default Category 2"),
        TrackerCategory(id: UUID(), title: "Default Category 3")
    ]
    
    var categories: [TrackerCategory] = []
    
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        try! self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()
        
        // add default categories at first run
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        let existingCategories = try context.fetch(fetchRequest)
        
        if existingCategories.isEmpty {
            for category in defaultCategories {
                let newCategory = TrackerCategoryCoreData(context: context)
                newCategory.categoryID = category.id.uuidString
                newCategory.title = category.title
                newCategory.creationDate = Date()
            }
            try context.save()
        } else {
            categories = try existingCategories.map { try category(from: $0) }
        }
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
    
    private func category(from categoryCoreData: TrackerCategoryCoreData) throws -> TrackerCategory {
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
}
