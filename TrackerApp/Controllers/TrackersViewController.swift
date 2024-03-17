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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YPWhite")
        
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        setUpNavigationBar()
    }
    
    private func setUpNavigationBar() {
        let button = UIButton()
        button.setImage(UIImage(named: "AddTrackerButtonBlack"), for: .normal)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let formattedDate = dateFormatter.string(from: selectedDate)
        print("Formatted date: \(formattedDate)")
    }
    
//    private func setUpTitleLabel() {
//        let label = UILabel()
//        titleLabel = label
//        
//        label.text = "Trackers"
//        label.textColor = UIColor(named: "YPBlack")
//        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(label)
//        
//        let guide = view.safeAreaLayoutGuide
//        NSLayoutConstraint.activate([
//            label.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 16),
//            label.topAnchor.constraint(equalTo: guide.topAnchor, constant: 1)
//        ])
//    }
    
//    private func setUpSearchBar() {
//        let searchBar = UISearchBar()
//        trackerSearchBar = searchBar
//        
//        searchBar.placeholder = "Search"
//        searchBar.searchBarStyle = .minimal
//        searchBar.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(searchBar)
//        
//        NSLayoutConstraint.activate([
//            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
//            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 6),
//            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -6)
//        ])
//    }
}

