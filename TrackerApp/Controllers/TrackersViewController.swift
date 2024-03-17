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
    private var categories: [TrackerCategory]?
    private var completedTrackers: [TrackerRecord]?
    private var dateFormatter = DateFormatter()
    private var trackerCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YPWhite")
        
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        setUpNavigationBar()
        setUpTitleLabel()
        setUpSearchBar()
        setUpCollectionView()
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
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.topAnchor.constraint(equalTo: trackerSearchBar.bottomAnchor, constant: 10),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
