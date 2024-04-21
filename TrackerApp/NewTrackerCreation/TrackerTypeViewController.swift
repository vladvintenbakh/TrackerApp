//
//  TrackerTypeViewController.swift
//  TrackerApp
//
//  Created by Vlad Vintenbakh on 18/3/24.
//

import UIKit

protocol TrackerTypeViewControllerDelegate: AnyObject {
    func didPickTrackerType(_ type: String)
}

final class TrackerTypeViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("trackerType.title", comment: "")
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor(named: "YPBlack")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var habitButton: UIButton = {
        let button = UIButton()
        
        button.backgroundColor = UIColor(named: "YPBlack")
        
        let buttonTitle = NSLocalizedString("trackerType.habitButton", comment: "")
        button.setTitle(buttonTitle, for: .normal)
        button.setTitleColor(UIColor(named: "YPWhite"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(habitButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var oneOffEventButton: UIButton = {
        let button = UIButton()
        
        button.backgroundColor = UIColor(named: "YPBlack")
        
        let buttonTitle = NSLocalizedString("trackerType.oneOffButton", comment: "")
        button.setTitle(buttonTitle, for: .normal)
        button.setTitleColor(UIColor(named: "YPWhite"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(oneOffEventButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    weak var delegate: TrackerTypeViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YPWhite")
        
        view.addSubview(titleLabel)
        view.addSubview(habitButton)
        view.addSubview(oneOffEventButton)
        
        setUpConstraints()
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
        delegate?.didPickTrackerType("New habit")
    }
    
    @objc private func oneOffEventButtonPressed() {
        delegate?.didPickTrackerType("New one-off event")
    }
}
