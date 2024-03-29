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
    
    private var categories: [TrackerCategory] = TrackerCategory.defaultCategories
    
    private var completedTrackers: Set<TrackerRecord> = []
    private var activeDate = Date()
    
    private var trackerCollectionView: UICollectionView!
    private var emptyPlaceholderView: UIView!
    
    private let geometricParams = GeometricParams(cellCount: 2,
                                                  leftInset: 16,
                                                  rightInset: 16,
                                                  cellSpacing: 10,
                                                  topInset: 8,
                                                  bottomInset: 16)
    
    private var visibleCategories: [TrackerCategory] {
        
        let weekday = Calendar.current.component(.weekday, from: activeDate)
        var categoriesToDisplay: [TrackerCategory] = []
        for category in categories {
            
            var trackersToDisplay: [Tracker] = []
            for item in category.trackers {
                let schedule = item.schedule
                if schedule != nil {
                    let scheduledWeekdays = Weekday.allCases[weekday > 1 ? weekday - 2 : weekday + 5]
                    if schedule!.contains(scheduledWeekdays) {
                        trackersToDisplay.append(item)
                    }
                } else {
                    trackersToDisplay.append(item)
                }
            }
            
            if !trackersToDisplay.isEmpty {
                let newCategory = TrackerCategory(title: category.title, trackers: trackersToDisplay)
                categoriesToDisplay.append(newCategory)
            }
            
        }
        
        let flag = !categoriesToDisplay.isEmpty
        hideEmptyPlaceholderView(flag)
        
        return categoriesToDisplay
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YPWhite")

        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        setUpNavigationBar()
        setUpTitleLabel()
        setUpSearchBar()
        setUpCollectionView()
        setUpEmptyCollectionPlaceholder()
    }
    
    private func setUpNavigationBar() {
        let button = UIButton(type: .system)
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .bold)
        let buttonImage = UIImage(systemName: "plus", withConfiguration: imageConfig)
        button.setImage(buttonImage, for: .normal)
        
        button.tintColor = UIColor(named: "YPBlack")
        
        button.addTarget(self, action: #selector(addTrackerButtonPressed), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.maximumDate = Date()
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        
        let datePickerContainer = UIView()
        datePickerContainer.addSubview(datePicker)
        
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: datePickerContainer.topAnchor),
            datePicker.bottomAnchor.constraint(equalTo: datePickerContainer.bottomAnchor),
            datePicker.leadingAnchor.constraint(equalTo: datePickerContainer.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: datePickerContainer.trailingAnchor),
            datePicker.widthAnchor.constraint(equalToConstant: 120)
        ])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePickerContainer)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func addTrackerButtonPressed() {
        let trackerTypeVC = TrackerTypeViewController()
        trackerTypeVC.delegate = self
        present(trackerTypeVC, animated: true)
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        activeDate = sender.date
        trackerCollectionView.reloadData()
    }
    
    private func setUpTitleLabel() {
        let label = UILabel()
        titleLabel = label
        
        label.text = "Trackers"
        label.textColor = UIColor(named: "YPBlack")
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1)
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
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        ])
    }
    
    private func setUpCollectionView() {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: UICollectionViewFlowLayout())
        trackerCollectionView = collectionView
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(TrackerCollectionViewCell.self,
                                forCellWithReuseIdentifier: TrackerCollectionViewCell.identifier)
        
        collectionView.register(CategoryHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: CategoryHeader.identifier)
        
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: trackerSearchBar.bottomAnchor, constant: 10),
            collectionView.bottomAnchor.constraint(equalTo: guide.bottomAnchor)
        ])
    }
    
    private func setUpEmptyCollectionPlaceholder() {
        let placeholderView = UIView()
        placeholderView.translatesAutoresizingMaskIntoConstraints = false
        emptyPlaceholderView = placeholderView
        view.addSubview(emptyPlaceholderView)
        
        let imageView = UIImageView(image: UIImage(named: "StarPlaceholder"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        placeholderView.addSubview(imageView)
        
        let label = UILabel()
        label.text = "Nothing here for now"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor(named: "YPBlack")
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        placeholderView.addSubview(label)
        
        NSLayoutConstraint.activate([
            placeholderView.leadingAnchor.constraint(equalTo: trackerCollectionView.leadingAnchor),
            placeholderView.trailingAnchor.constraint(equalTo: trackerCollectionView.trailingAnchor),
            placeholderView.topAnchor.constraint(equalTo: trackerCollectionView.topAnchor),
            placeholderView.bottomAnchor.constraint(equalTo: trackerCollectionView.bottomAnchor),
            
            imageView.centerXAnchor.constraint(equalTo: placeholderView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: placeholderView.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: trackerCollectionView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trackerCollectionView.trailingAnchor)
        ])
    }
    
    private func hideEmptyPlaceholderView(_ flag: Bool) {
        emptyPlaceholderView.isHidden = flag
    }
}

extension TrackersViewController: TrackerTypeViewControllerDelegate {
    func didPickTrackerType(_ type: String) {
        dismiss(animated: true)
        let trackerOptionsMenuVC = TrackerOptionsMenuViewController(trackerType: type)
        trackerOptionsMenuVC.delegate = self
        present(trackerOptionsMenuVC, animated: true)
    }
}

extension TrackersViewController: TrackerOptionsMenuViewControllerDelegate {
    func didPressCancelButton() {
        dismiss(animated: true)
    }
    
    func didPressCreateButton(category: String, newTracker: Tracker) {
        dismiss(animated: true)
        
        var index: Int?
        for i in 0..<categories.count {
            if categories[i].title == category {
                index = i
            }
        }
        guard let index else { return }
        
        let newTrackerList = categories[index].trackers + [newTracker]
        categories[index] = TrackerCategory(title: category,
                                            trackers: newTrackerList)
        
        trackerCollectionView.reloadData()
    }
}

extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackerCollectionViewCell.identifier,
            for: indexPath
        ) as? TrackerCollectionViewCell
        guard let cell else { return UICollectionViewCell() }
        cell.delegate = self
        
        let currentSection = indexPath.section
        let currentRow = indexPath.row
        
        let tracker = visibleCategories[currentSection].trackers[currentRow]
        let completionStatus = completedTrackers.contains { $0.id == tracker.id && $0.date == activeDate}
        
        let completedDays = completedTrackers.filter { $0.id == tracker.id }
        let dayCount = completedDays.count
        
        cell.updateContent(tracker: tracker,
                           completionStatus: completionStatus,
                           dayCount: dayCount)
        
        return cell
    }
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableSpace = collectionView.frame.width - geometricParams.paddingWidth
        let cellWidth: CGFloat = availableSpace / CGFloat(geometricParams.cellCount)
        let cellHeight: CGFloat = 148
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: geometricParams.topInset,
                            left: geometricParams.leftInset,
                            bottom: geometricParams.bottomInset,
                            right: geometricParams.rightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: CategoryHeader.identifier,
                for: indexPath
            ) as? CategoryHeader
            guard let headerView else { return UICollectionReusableView() }
            
            let headerText = visibleCategories[indexPath.section].title
            headerView.setText(headerText)
            
            return headerView
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(
            collectionView,
            viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader,
            at: indexPath
        )
        
        let size = CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height)
        return headerView.systemLayoutSizeFitting(size,
                                                  withHorizontalFittingPriority: .required,
                                                  verticalFittingPriority: .fittingSizeLevel)
        
    }
}

extension TrackersViewController: UICollectionViewDelegate {
    
}

extension TrackersViewController: TrackerCollectionViewCellDelegate {
    func didMarkDayCompleted(for tracker: Tracker, cell: TrackerCollectionViewCell) {
        let trackerRecord = TrackerRecord(id: tracker.id, date: activeDate)
        
        var trackerFound = false
        for item in completedTrackers {
            if (item.id == trackerRecord.id) && (item.date == activeDate) {
                trackerFound = true
            }
        }
        
        if trackerFound {
            completedTrackers.remove(trackerRecord)
            
            cell.decrementDayCount()
            cell.changeCompletionStatus(to: false)
        } else {
            completedTrackers.insert(trackerRecord)
            
            cell.incrementDayCount()
            cell.changeCompletionStatus(to: true)
        }
    }
}
