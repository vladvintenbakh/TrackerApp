//
//  CategorySelectionViewModel.swift
//  TrackerApp
//
//  Created by Vlad Vintenbakh on 14/4/24.
//

import Foundation

typealias Binding<T> = (T) -> Void
typealias SimpleBinding = () -> Void

final class CategorySelectionViewModel {
    
    var onCategoriesUpdateStateChange: SimpleBinding?
    var onCategorySelectionStateChange: Binding<TrackerCategory>?
    
    private let trackerCategoryStore = TrackerCategoryStore()
    
    var categories: [TrackerCategory] = [] {
        didSet {
            onCategoriesUpdateStateChange?()
        }
    }
    
    var pickedCategory: TrackerCategory? = nil {
        didSet {
            guard let pickedCategory else { return }
            onCategorySelectionStateChange?(pickedCategory)
        }
    }
    
    init() {
        trackerCategoryStore.delegate = self
    }
    
    func setPickedCategory(position indexPath: IndexPath) {
        let currentRow = indexPath.row
        pickedCategory = categories[currentRow]
    }
    
    func createCategory(categoryObject: TrackerCategory.CategoryObject) {
        do {
            
            if categories.contains(where: { $0.id == categoryObject.id }) {
                try trackerCategoryStore.editCategoryObject(newCategoryObject: categoryObject)
            } else {
                let newCategory = TrackerCategory(id: UUID(), title: categoryObject.title)
                try trackerCategoryStore.addCategoryToCoreData(newCategory)
            }
            
            loadCategoriesFromStorage()
        } catch {
            print("Error updating categories: \(error)")
        }
    }
    
    func loadCategoriesFromStorage() {
        do {
            let storeCategories = try trackerCategoryStore.fetchedCategoryObjectList.map {
                try trackerCategoryStore.category(from: $0)
            }
            categories = storeCategories
        } catch {
            print("Failed to fetch categories")
            categories = []
        }
    }
    
    func deleteCategory(_ categoryObject: TrackerCategory) {
        do {
            if categoryObject == pickedCategory { pickedCategory = nil }
            try trackerCategoryStore.deleteCategoryObject(categoryObject: categoryObject)
            loadCategoriesFromStorage()
        } catch {
            print("Error deleting category \(error)")
        }
    }
}

extension CategorySelectionViewModel: TrackerCategoryStoreDelegate {
    func didUpdateCategories() {
        loadCategoriesFromStorage()
    }
}
