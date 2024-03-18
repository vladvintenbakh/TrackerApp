//
//  TrackerTypeViewController.swift
//  TrackerApp
//
//  Created by Vlad Vintenbakh on 18/3/24.
//

import UIKit

class TrackerTypeViewController: UIViewController {
    
    private var titleLabel: UILabel!
    private var habitButton: UIButton!
    private var oneOffEventButton: UIButton!
    
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
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        habitButton = button
        
        button.setTitle("Habit", for: .normal)
        button.setTitleColor(UIColor(named: "YPWhite"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = UIColor(named: "YPBlack")
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(habitButtonPressed), for: .touchUpInside)
        
        view.addSubview(button)
    }
    
    private func setUpOneOffEventButton() {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        oneOffEventButton = button
        
        button.setTitle("One-Off Event", for: .normal)
        button.setTitleColor(UIColor(named: "YPWhite"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = UIColor(named: "YPBlack")
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(oneOffEventButtonPressed), for: .touchUpInside)
        
        view.addSubview(button)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
            
            habitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                 constant: 20),
            habitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                  constant: -20),
            habitButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            
            oneOffEventButton.leadingAnchor.constraint(equalTo: habitButton.leadingAnchor),
            oneOffEventButton.trailingAnchor.constraint(equalTo: habitButton.trailingAnchor),
            oneOffEventButton.heightAnchor.constraint(equalTo: habitButton.heightAnchor),
            oneOffEventButton.topAnchor.constraint(equalTo: habitButton.bottomAnchor, constant: 16)
        ])
    }
    
    @objc private func habitButtonPressed() {
        
    }
    
    @objc private func oneOffEventButtonPressed() {
        
    }
}
