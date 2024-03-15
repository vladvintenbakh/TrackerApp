//
//  ViewController.swift
//  TrackerApp
//
//  Created by Vlad Vintenbakh on 8/3/24.
//

import UIKit

class TrackersViewController: UIViewController {
    
    private var addTrackerButton: UIButton!
    private var trackerDatePicker: UIDatePicker!
    private var titleLabel: UILabel!
    private var trackerSearchBar: UISearchBar!
    private var categories: [TrackerCategory]?
    private var completedTrackers: [TrackerRecord]?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YPWhite")
        setUpAddTrackerButton()
        setUpDatePicker()
        setUpTitleLabel()
        setUpSearchBar()
    }
    
    private func setUpAddTrackerButton() {
        let button = UIButton()
        addTrackerButton = button
        
        button.setImage(UIImage(named: "AddTrackerButtonBlack"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 42),
            button.heightAnchor.constraint(equalToConstant: 42),
            button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
            button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 6)
        ])
    }
    
    private func setUpDatePicker() {
        let datePicker = UIDatePicker()
        trackerDatePicker = datePicker
        
        datePicker.datePickerMode = .date
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(datePicker)
        
        NSLayoutConstraint.activate([
            datePicker.centerYAnchor.constraint(equalTo: addTrackerButton.centerYAnchor),
            datePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    private func setUpTitleLabel() {
        let label = UILabel()
        titleLabel = label
        
        label.text = "Trackers"
        label.textColor = UIColor(named: "YPBlack")
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            label.topAnchor.constraint(equalTo: addTrackerButton.bottomAnchor, constant: 1)
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
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 6),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -6)
        ])
    }
}

