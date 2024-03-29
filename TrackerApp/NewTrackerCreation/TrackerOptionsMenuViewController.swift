//
//  OneOffEventCreationViewController.swift
//  TrackerApp
//
//  Created by Vlad Vintenbakh on 18/3/24.
//

import UIKit

protocol TrackerOptionsMenuViewControllerDelegate: AnyObject {
    func didPressCancelButton()
    func didPressCreateButton(category: String, newTracker: Tracker)
}

class TrackerOptionsMenuViewController: UIViewController {
    private var pageScrollView: UIScrollView!
    private var mainContentArea: UIView!
    private var titleLabel: UILabel!
    private var trackerNameTextField: UITextField!
    private var optionsTableView: UITableView!
    private var emojiCollectionView: UICollectionView!
    private var colorCollectionView: UICollectionView!
    private var cancelButton: UIButton!
    private var createButton: UIButton!
    private var actionButtonStackView: UIStackView!
    
    private let trackerCreationHelper = TrackerCreationHelper()
    private let trackerType: String

    private var trackerObject: Tracker.TrackerObject {
        didSet {
            validateFormFields()
        }
    }
    
    private var category: String? = TrackerCategory.pickDefaultCategory().title {
        didSet {
            validateFormFields()
        }
    }
    
    private let geometricParams = GeometricParams(cellCount: 6,
                                                  leftInset: 18,
                                                  rightInset: 18,
                                                  cellSpacing: 5,
                                                  topInset: 24,
                                                  bottomInset: 24)
    
    weak var delegate: TrackerOptionsMenuViewControllerDelegate?
    
    private var scheduleValueText: String? {
        let schedule = trackerObject.schedule
        guard let schedule else { return nil }
        
        if schedule.count == 7 {
            return "Every day"
        }
        
        var conciseNotationList: [String] = []
        for item in schedule {
            var stringToAdd: String
            switch item {
            case .mon:
                stringToAdd = "Mon"
            case .tue:
                stringToAdd = "Tue"
            case .wed:
                stringToAdd = "Wed"
            case .thu:
                stringToAdd = "Thu"
            case .fri:
                stringToAdd = "Fri"
            case .sat:
                stringToAdd = "Sat"
            case .sun:
                stringToAdd = "Sun"
            }
            conciseNotationList.append(stringToAdd)
        }
        
        let result = conciseNotationList.joined(separator: ", ")
        return result
    }
    
    private let textFieldLimitMessage: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = UIColor(named: "YPRed")
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YPWhite")
        
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        setUpScrollView()
        
        setUpMainContentArea()
        
        setUpTitleLabel()
        setUpTrackerNameTextField()
        setUpOptionsTable()
        setUpEmojiCollectionView()
        setUpColorCollectionView()
        setUpActionButtons()
        addRelativeConstraints()
        
        validateFormFields()
    }
    
    init(trackerType: String, trackerObject: Tracker.TrackerObject = Tracker.TrackerObject()) {
        self.trackerType = trackerType
        self.trackerObject = trackerObject
        self.trackerObject.schedule = trackerType == "New habit" ? [] : nil
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
                                                           text: trackerType)
        titleLabel = label
    }
    
    private func setUpTrackerNameTextField() {
        let textField = trackerCreationHelper.createTrackerNameTextField(view: mainContentArea)
        textField.addTarget(self, action: #selector(changedTextFieldInput), for: .editingChanged)
        trackerNameTextField = textField
    }
    
    private func setUpOptionsTable() {
        var tableView: UITableView
        if trackerType == "New habit" {
            tableView = trackerCreationHelper.createTrackerOptionsTableView(view: mainContentArea,
                                                                            height: 75 * 2)
        } else {
            tableView = trackerCreationHelper.createTrackerOptionsTableView(view: mainContentArea,
                                                                            height: 75)
        }
        
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
        cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        self.cancelButton = cancelButton
        
        let createButton = trackerCreationHelper.createActionButton(text: "Create")
        createButton.backgroundColor = UIColor(named: "YPBlack")
        createButton.setTitleColor(UIColor(named: "YPWhite"), for: .normal)
        createButton.isEnabled = false
        createButton.addTarget(self, action: #selector(createButtonPressed), for: .touchUpInside)
        createButton.isEnabled = false
        createButton.backgroundColor = UIColor(named: "YPGray")
        self.createButton = createButton
        
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
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func changedTextFieldInput(_ sender: UITextField) {
        guard let input = sender.text else { return }
        trackerObject.name = input
    }
    
    @objc private func cancelButtonPressed() {
        delegate?.didPressCancelButton()
    }
    
    @objc private func createButtonPressed() {
        guard let category,
              let emoji = trackerObject.emoji,
              let color = trackerObject.color 
        else { return }
        
        let tracker = Tracker(id: UUID(),
                              name: trackerObject.name,
                              emoji: emoji,
                              color: color,
                              schedule: trackerObject.schedule)
        
        delegate?.didPressCreateButton(category: category, newTracker: tracker)
    }
    
    private func validateFormFields() {
        
        var violatingConditions = [
            trackerObject.name.count == 0,
            trackerObject.emoji == nil,
            trackerObject.color == nil,
            category == nil
        ]
        
        if let schedule = trackerObject.schedule {
            let scheduleCondition = schedule.isEmpty
            violatingConditions.append(scheduleCondition)
        }
        
        for condition in violatingConditions {
            if condition {
                enableCreateButton(false)
                return
            }
        }
        
        enableCreateButton(true)
    }
    
    private func enableCreateButton(_ flag: Bool) {
        if flag {
            createButton.isEnabled = true
            createButton.backgroundColor = UIColor(named: "YPBlack")
        } else {
            createButton.isEnabled = false
            createButton.backgroundColor = UIColor(named: "YPGray")
        }
    }
}

extension TrackerOptionsMenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if trackerType == "New habit" {
            return 2
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = optionsTableView.dequeueReusableCell(
            withIdentifier: TrackerOptionsTableViewCell.identifier,
            for: indexPath
        ) as! TrackerOptionsTableViewCell
        
        let currentRow = indexPath.row
        
        var cellType: String = "Middle"
        
        if currentRow == 0 {
            if category != nil { cell.setValue(category!) }
            cellType = "First"
        }
        
        if currentRow == 1 {
            cell.setLabelText("Schedule")
            if scheduleValueText != nil { cell.setValue(scheduleValueText!) }
            cellType = "Last"
        }
        
        if trackerObject.schedule == nil { cellType = "None" }
        
        cell.configCustomCell(cellType: cellType)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

extension TrackerOptionsMenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentRow = indexPath.row
        if currentRow == 1 {
            let schedule = trackerObject.schedule
            guard let schedule else { return }
            
            let selectedWeekdaySet = Set(schedule)
            let scheduleSelectionVC = ScheduleSelectionViewController(selectedWeekdaySet: selectedWeekdaySet)
            scheduleSelectionVC.delegate = self
            
            let navigationVC = UINavigationController(rootViewController: scheduleSelectionVC)
            present(navigationVC, animated: true)
        }
    }
}

extension TrackerOptionsMenuViewController: ScheduleSelectionViewControllerDelegate {
    func didSelectWeekdays(_ weekdays: [Weekday]) {
        trackerObject.schedule = weekdays
        
        optionsTableView.reloadData()
        dismiss(animated: true)
    }
}

extension TrackerOptionsMenuViewController: UICollectionViewDataSource {
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

extension TrackerOptionsMenuViewController: UICollectionViewDelegateFlowLayout {
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
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
            let indexPath = IndexPath(row: 0, section: section)
        
            let headerView = self.collectionView(
                collectionView,
                viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader,
                at: indexPath
            )
            
            return headerView.systemLayoutSizeFitting(
                CGSize(
                    width: collectionView.frame.width,
                    height: UIView.layoutFittingExpandedSize.height
                ),
                withHorizontalFittingPriority: .required,
                verticalFittingPriority: .fittingSizeLevel
            )
    }
}

extension TrackerOptionsMenuViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == emojiCollectionView {
            let cell = collectionView.cellForItem(at: indexPath) as? EmojiCollectionViewCell
            guard let cell else { return }
            
            let currentRow = indexPath.row
            trackerObject.emoji = emojis[currentRow]
            
            cell.contentView.backgroundColor = UIColor(named: "YPLightGray")
        } else if collectionView == colorCollectionView {
            let cell = collectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell
            guard let cell else { return }
            
            let currentRow = indexPath.row
            let color = colorOptions[currentRow]
            trackerObject.color = color
            
            cell.contentView.layer.borderWidth = 3
            cell.contentView.layer.borderColor = color.withAlphaComponent(0.3).cgColor
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == emojiCollectionView {
            let cell = collectionView.cellForItem(at: indexPath) as? EmojiCollectionViewCell
            guard let cell else { return }
            
            cell.contentView.backgroundColor = .clear
        } else if collectionView == colorCollectionView {
            let cell = collectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell
            guard let cell else { return }
            
            cell.contentView.layer.borderWidth = 0
        }
    }
}
