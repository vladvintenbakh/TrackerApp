//
//  OneOffEventCreationViewController.swift
//  TrackerApp
//
//  Created by Vlad Vintenbakh on 18/3/24.
//

import UIKit

class OneOffEventViewController: UIViewController {
    private var pageScrollView: UIScrollView!
    private var mainContentArea: UIView!
    private var titleLabel: UILabel!
    private var trackerNameTextField: UITextField!
    private var optionsTableView: UITableView!
    private var emojiCollectionView: UICollectionView!
    private var colorCollectionView: UICollectionView!
    private var actionButtonStackView: UIStackView!
    
    private let trackerCreationHelper = TrackerCreationHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YPWhite")
        
        setUpScrollView()
        
        setUpMainContentArea()
        
        setUpTitleLabel()
        setUpTrackerNameTextField()
        setUpCategoryButton()
        setUpEmojiCollectionView()
        setUpColorCollectionView()
        setUpActionButtons()
        addRelativeConstraints()
    }
    
    private func setUpScrollView() {
        let scrollView = trackerCreationHelper.createPageScrollView(view: view)
        
        pageScrollView = scrollView
    }
    
    private func setUpMainContentArea() {
        let contentView = trackerCreationHelper.createMainContentView(view: pageScrollView)
        
        mainContentArea = contentView
    }
    
    private func setUpTitleLabel() {
        let label = trackerCreationHelper.createTitleLabel(view: mainContentArea,
                                                           text: "New one-off event")
        titleLabel = label
    }
    
    private func setUpTrackerNameTextField() {
        let textField = trackerCreationHelper.createTrackerNameTextField(view: mainContentArea)
        trackerNameTextField = textField
    }
    
    private func setUpCategoryButton() {
        let tableView = trackerCreationHelper.createTrackerOptionsTableView(view: mainContentArea,
                                                                            height: 75)
        optionsTableView = tableView
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setUpEmojiCollectionView() {
        let collection = trackerCreationHelper.createCollectionView(view: mainContentArea)
        emojiCollectionView = collection
        
        collection.register(EmojiCollectionViewCell.self,
                            forCellWithReuseIdentifier: EmojiCollectionViewCell.identifier)
        
//        collection.dataSource = self
//        collection.delegate = self
    }
    
    private func setUpColorCollectionView() {
        let collection = trackerCreationHelper.createCollectionView(view: mainContentArea)
        colorCollectionView = collection
        
        collection.register(ColorCollectionViewCell.self,
                            forCellWithReuseIdentifier: ColorCollectionViewCell.identifier)
        
//        collection.dataSource = self
//        collection.delegate = self
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
        
        mainContentArea.addSubview(stackView)
    }
    
    private func addRelativeConstraints() {
        NSLayoutConstraint.activate([
            trackerNameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                                      constant: 38),
            
            optionsTableView.topAnchor.constraint(equalTo: trackerNameTextField.bottomAnchor,
                                                  constant: 24),
            
            emojiCollectionView.topAnchor.constraint(equalTo: optionsTableView.bottomAnchor,
                                                     constant: 32),
            
            colorCollectionView.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor,
                                                     constant: 16),
            
            actionButtonStackView.leadingAnchor.constraint(
                equalTo: mainContentArea.leadingAnchor, constant: 20
            ),
            actionButtonStackView.trailingAnchor.constraint(
                equalTo: mainContentArea.trailingAnchor, constant: -20
            ),
            actionButtonStackView.bottomAnchor.constraint(
                equalTo: mainContentArea.bottomAnchor
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
