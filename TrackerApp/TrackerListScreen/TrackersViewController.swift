//
//  ViewController.swift
//  TrackerApp
//
//  Created by Vlad Vintenbakh on 8/3/24.
//

import UIKit

class TrackersViewController: UIViewController {
    
    private var titleLabel: UILabel!
    private var trackerSearchBar: UISearchBar!
    private var categories: [TrackerCategory] = TrackerCategory.defaultCategories
    private var completedTrackers: [TrackerRecord]?
    private var dateFormatter = DateFormatter()
    private var trackerCollectionView: UICollectionView!
    private var emptyPlaceholderView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YPWhite")
        
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        setUpNavigationBar()
        setUpTitleLabel()
        setUpSearchBar()
        setUpCollectionView()
        setUpEmptyCollectionPlaceholder()
    }
    
    private func setUpNavigationBar() {
        
        let button = UIButton()
        button.setImage(UIImage(named: "AddTrackerButtonBlack"), for: .normal)
        button.addTarget(self, action: #selector(addTrackerButtonPressed), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
    }
    
    @objc private func addTrackerButtonPressed() {
        let trackerTypeVC = TrackerTypeViewController()
        trackerTypeVC.delegate = self
        present(trackerTypeVC, animated: true)
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let formattedDate = dateFormatter.string(from: selectedDate)
        print("Formatted date: \(formattedDate)")
    }
    
    private func setUpTitleLabel() {
        let label = UILabel()
        titleLabel = label
        
        label.text = "Trackers"
        label.textColor = UIColor(named: "YPBlack")
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1)
        ])
    }
    
    private func setUpSearchBar() {
        let searchBar = UISearchBar()
        trackerSearchBar = searchBar
        
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .minimal
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setUpCollectionView() {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: UICollectionViewFlowLayout())
        trackerCollectionView = collectionView
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.topAnchor.constraint(equalTo: trackerSearchBar.bottomAnchor, constant: 10),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setUpEmptyCollectionPlaceholder() {
        let placeholderView = UIView()
        placeholderView.translatesAutoresizingMaskIntoConstraints = false
        emptyPlaceholderView = placeholderView
        view.addSubview(emptyPlaceholderView)
        
        let imageView = UIImageView(image: UIImage(named: "StarPlaceholder"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        placeholderView.addSubview(imageView)
        
        let label = UILabel()
        label.text = "What shall we track?"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor(named: "YPBlack")
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        placeholderView.addSubview(label)
        
        NSLayoutConstraint.activate([
            placeholderView.leadingAnchor.constraint(equalTo: trackerCollectionView.leadingAnchor),
            placeholderView.trailingAnchor.constraint(equalTo: trackerCollectionView.trailingAnchor),
            placeholderView.topAnchor.constraint(equalTo: trackerCollectionView.topAnchor),
            placeholderView.bottomAnchor.constraint(equalTo: trackerCollectionView.bottomAnchor),
            
            imageView.centerXAnchor.constraint(equalTo: placeholderView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: placeholderView.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: trackerCollectionView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trackerCollectionView.trailingAnchor)
        ])
    }
}

extension TrackersViewController: TrackerTypeViewControllerDelegate {
    func didPickTrackerType(_ type: String) {
        dismiss(animated: true)
        let trackerOptionsMenuVC = TrackerOptionsMenuViewController(trackerType: type)
        trackerOptionsMenuVC.delegate = self
        present(trackerOptionsMenuVC, animated: true)
    }
}

extension TrackersViewController: TrackerOptionsMenuViewControllerDelegate {
    func didPressCancelButton() {
        dismiss(animated: true)
    }
    
    func didPressCreateButton(category: String, newTracker: Tracker) {
        dismiss(animated: true)
        
        var index: Int?
        for i in 0..<categories.count {
            if categories[i].title == category {
                index = i
            }
        }
        guard let index else { return }
        
        let newTrackerList = categories[index].trackers + [newTracker]
        categories[index] = TrackerCategory(title: category,
                                            trackers: newTrackerList)
        trackerCollectionView.reloadData()
    }
}
