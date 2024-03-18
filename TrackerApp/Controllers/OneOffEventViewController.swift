//
//  OneOffEventCreationViewController.swift
//  TrackerApp
//
//  Created by Vlad Vintenbakh on 18/3/24.
//

import UIKit

class OneOffEventViewController: UIViewController {
    private var titleLabel: UILabel!
    private var trackerNameTextField: UITextField!
    private var optionsTableView: UITableView!
    private var emojiCollectionLabel: UILabel!
    private var emojiCollectionView: UICollectionView!
    private var colorCollectionLabel: UILabel!
    private var colorCollectionView: UICollectionView!
    private var actionButtonStackView: UIStackView!
    
    private let trackerCreationHelper = TrackerCreationHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YPWhite")
        
        setUpTitleLabel()
        setUpTrackerNameTextField()
        setUpCategoryButton()
        setUpEmojiCollectionLabel()
        setUpEmojiCollectionView()
        setUpColorCollectionLabel()
        setUpColorCollectionView()
        setUpActionButtons()
        addRelativeConstraints()
    }
    
    private func setUpTitleLabel() {
        let label = trackerCreationHelper.createTitleLabel(view: view, text: "New one-off event")
        titleLabel = label
    }
    
    private func setUpTrackerNameTextField() {
        let textField = trackerCreationHelper.createTrackerNameTextField(view: view)
        trackerNameTextField = textField
    }
    
    private func setUpCategoryButton() {
        let tableView = trackerCreationHelper.createTrackerOptionsTableView(view: view, height: 75)
        optionsTableView = tableView
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TrackerOptionsTableViewCell.self,
                           forCellReuseIdentifier: TrackerOptionsTableViewCell.identifier)
    }
    
    private func setUpEmojiCollectionLabel() {
        let label = trackerCreationHelper.createCollectionLabel(view: view, text: "Emoji")
        emojiCollectionLabel = label
    }
    
    private func setUpEmojiCollectionView() {
        let collection = trackerCreationHelper.createCollectionView(view: view)
        emojiCollectionView = collection
    }
    
    private func setUpColorCollectionLabel() {
        let label = trackerCreationHelper.createCollectionLabel(view: view, text: "Color")
        colorCollectionLabel = label
    }
    
    private func setUpColorCollectionView() {
        let collection = trackerCreationHelper.createCollectionView(view: view)
        colorCollectionView = collection
    }
    
    private func setUpActionButtons() {
        let cancelButton = trackerCreationHelper.createActionButton(text: "Cancel")
        cancelButton.setTitleColor(UIColor(named: "YPRed"), for: .normal)
        cancelButton.layer.borderColor = UIColor(named: "YPRed")?.cgColor
        cancelButton.layer.borderWidth = 1
        
        let createButton = trackerCreationHelper.createActionButton(text: "Create")
        createButton.backgroundColor = UIColor(named: "YPBlack")
        createButton.setTitleColor(UIColor(named: "YPWhite"), for: .normal)
        
        let stackView = UIStackView(arrangedSubviews: [cancelButton, createButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        actionButtonStackView = stackView
        view.addSubview(stackView)
    }
    
    private func addRelativeConstraints() {
        NSLayoutConstraint.activate([
            trackerNameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            
            optionsTableView.topAnchor.constraint(equalTo: trackerNameTextField.bottomAnchor,
                                                  constant: 24),
            
            emojiCollectionLabel.topAnchor.constraint(equalTo: optionsTableView.bottomAnchor,
                                                      constant: 32),
            
            emojiCollectionView.topAnchor.constraint(equalTo: emojiCollectionLabel.bottomAnchor),
            
            colorCollectionLabel.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor,
                                                      constant: 16),
            
            colorCollectionView.topAnchor.constraint(equalTo: colorCollectionLabel.bottomAnchor),
            
            actionButtonStackView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20
            ),
            actionButtonStackView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20
            ),
            actionButtonStackView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor
            ),
            actionButtonStackView.topAnchor.constraint(
                equalTo: colorCollectionView.bottomAnchor,
                constant: 16
            )
        ])
    }
}

extension OneOffEventViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = optionsTableView.dequeueReusableCell(
            withIdentifier: TrackerOptionsTableViewCell.identifier,
            for: indexPath
        ) as! TrackerOptionsTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

extension OneOffEventViewController: UITableViewDelegate {
    
}
