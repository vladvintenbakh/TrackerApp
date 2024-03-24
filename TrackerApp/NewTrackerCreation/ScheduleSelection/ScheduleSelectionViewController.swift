//
//  ScheduleSelectionViewController.swift
//  TrackerApp
//
//  Created by Vlad Vintenbakh on 24/3/24.
//

import UIKit

protocol ScheduleSelectionViewControllerDelegate: AnyObject {
    
}

class ScheduleSelectionViewController: UIViewController {
    private let weekdayTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        
        tableView.backgroundColor = .systemYellow // remove later
        
        // register cell here
        
        return tableView
    }()
    
    private let doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.setTitleColor(UIColor(named: "YPWhite"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = UIColor(named: "YPBlack")
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(ScheduleSelectionViewController.self,
                         action: #selector(pressedDoneButton),
                         for: .touchUpInside)
        
        return button
    }()
    
    weak var delegate: ScheduleSelectionViewControllerDelegate?
    private var selectedWeekdaySet: Set<Weekday> = []
    
    init(selectedWeekdayArray: [Weekday]) {
        self.selectedWeekdaySet = Set(selectedWeekdayArray)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Schedule"
        
        view.addSubview(weekdayTableView)
        view.addSubview(doneButton)
    }
    
    private func setUpConstraints() {
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            weekdayTableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 16),
            weekdayTableView.trailingAnchor.constraint(equalTo: guide.leadingAnchor, constant: -16),
            weekdayTableView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 16),
            
            doneButton.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func pressedDoneButton() {
        
    }
    
    
}
