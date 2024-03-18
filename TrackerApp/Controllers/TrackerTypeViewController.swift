//
//  TrackerTypeViewController.swift
//  TrackerApp
//
//  Created by Vlad Vintenbakh on 18/3/24.
//

import UIKit

class TrackerTypeViewController: UIViewController {
    
    private var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YPWhite")
        
        setUpTitleLabel()
        setUpHabitButton()
        setUpOneOffEventButton()
        setUpConstraints()
    }
    
    private func setUpTitleLabel() {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        titleLabel = label
        
        label.text = "Tracker creation"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor(named: "YPBlack")
        view.addSubview(label)
    }
    
    private func setUpHabitButton() {
        
    }
    
    private func setUpOneOffEventButton() {
        
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27)
        ])
    }
}
