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
    
    private let geometricParams = GeometricParams(cellCount: 6,
                                                  leftInset: 18,
                                                  rightInset: 18,
                                                  cellSpacing: 5,
                                                  topInset: 24,
                                                  bottomInset: 24)
    
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
        
        collection.register(CollectionHeader.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: CollectionHeader.identifier)
        
        collection.dataSource = self
        collection.delegate = self
    }
    
    private func setUpColorCollectionView() {
        let collection = trackerCreationHelper.createCollectionView(view: mainContentArea)
        colorCollectionView = collection
        
        collection.register(ColorCollectionViewCell.self,
                            forCellWithReuseIdentifier: ColorCollectionViewCell.identifier)
        
        collection.register(CollectionHeader.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: CollectionHeader.identifier)
        
        collection.dataSource = self
        collection.delegate = self
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
            emojiCollectionView.heightAnchor.constraint(
                equalToConstant: calculateEmojiCollectionHeight()
            ),
            
            colorCollectionView.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor,
                                                     constant: 16),
            colorCollectionView.heightAnchor.constraint(
                equalToConstant: calculateColorCollectionHeight()
            ),
            
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
    
    private func calculateEmojiCollectionHeight() -> CGFloat {
        let emojiCount = CGFloat(emojis.count)
        let contentHeight = emojiCount / CGFloat(geometricParams.cellCount) * cellHeight
        return contentHeight + geometricParams.topInset + geometricParams.bottomInset + 18
    }
    
    private func calculateColorCollectionHeight() -> CGFloat {
        let colorCount = CGFloat(colorOptions.count)
        let contentHeight = colorCount / CGFloat(geometricParams.cellCount) * cellHeight
        return contentHeight + geometricParams.topInset + geometricParams.bottomInset + 18
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

extension OneOffEventViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, 
                        numberOfItemsInSection section: Int) -> Int {
        if collectionView == emojiCollectionView {
            return emojis.count
        } else if collectionView == colorCollectionView {
            return colorOptions.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, 
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == emojiCollectionView {
            let currentEmoji = emojis[indexPath.row]
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: EmojiCollectionViewCell.identifier,
                for: indexPath
            ) as? EmojiCollectionViewCell
            cell?.setEmoji(currentEmoji)
            return cell!
        } else if collectionView == colorCollectionView {
            let currentColor = colorOptions[indexPath.row]
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ColorCollectionViewCell.identifier,
                for: indexPath
            ) as? ColorCollectionViewCell
            cell?.setColor(currentColor)
            return cell!
        }
        return UICollectionViewCell()
    }
}

extension OneOffEventViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, 
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let contentSpace = collectionView.frame.width - geometricParams.paddingWidth
        let width = contentSpace / CGFloat(geometricParams.cellCount)
        return CGSize(width: width, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, 
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return geometricParams.cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, 
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let insets = UIEdgeInsets(top: geometricParams.topInset,
                                  left: geometricParams.leftInset,
                                  bottom: geometricParams.bottomInset,
                                  right: geometricParams.rightInset)
        return insets
    }
    
    func collectionView(_ collectionView: UICollectionView, 
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, 
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        var headerText: String
        if collectionView == emojiCollectionView {
            headerText = "Emoji"
        } else if collectionView == colorCollectionView {
            headerText = "Color"
        } else {
            headerText = ""
        }
        
        if kind == UICollectionView.elementKindSectionHeader {
            let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: CollectionHeader.identifier,
                for: indexPath
            ) as? CollectionHeader
            view?.setHeaderText(headerText)
            return view!
        }
        return UICollectionReusableView()
    }
    
    // ADD HEADER REFERENCE SIZE
}
