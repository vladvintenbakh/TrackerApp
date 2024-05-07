//
//  ViewController.swift
//  TrackerApp
//
//  Created by Vlad Vintenbakh on 8/3/24.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    private var titleLabel: UILabel!
    private var trackerSearchBar: UISearchBar!
    private var trackerCollectionView: UICollectionView!
    private var emptyPlaceholderView: UIView!
    private var filtersButton: UIButton!
    private var datePicker: UIDatePicker!
    private var emptyPlaceholderImageView: UIImageView!
    private var emptyPlaceholderLabel: UILabel!
    
    private var categories: [TrackerCategory] = []
    private var completedTrackers: Set<TrackerRecord> = []
    private var trackerToEdit: Tracker?
    
    private var activeDate = Date.safeDate(Date())!
    private var activeFilter: FilterOptions = .all
    
    private let trackerStore = TrackerStore()
    private let trackerCategoryStore = TrackerCategoryStore()
    private let trackerRecordStore = TrackerRecordStore()
    private let geometricParams = GeometricParams(cellCount: 2,
                                                  leftInset: 16,
                                                  rightInset: 16,
                                                  cellSpacing: 10,
                                                  topInset: 8,
                                                  bottomInset: 16)
    
    private let analyticsService = AnalyticsService()
    
    private var searchText = "" {
        didSet {
            loadFilteredData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "DynamicBackground")

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
        setUpFiltersButton()
        
        trackerSearchBar.delegate = self
        
        trackerStore.delegate = self
        trackerRecordStore.delegate = self
        
        loadFilteredData()
        
        hideEmptyPlaceholderView(trackerStore.numberOfTrackers != 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        analyticsService.report(event: "open", params: ["screen": "Main"])
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        analyticsService.report(event: "close", params: ["screen": "Main"])
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
        self.datePicker = datePicker
        
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.maximumDate = Date()
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        
        datePicker.overrideUserInterfaceStyle = .light
        
        let datePickerContainer = UIView()
        datePickerContainer.addSubview(datePicker)
        
        datePickerContainer.layer.cornerRadius = 8
        datePickerContainer.backgroundColor = .white
        datePickerContainer.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: datePickerContainer.topAnchor),
            datePicker.bottomAnchor.constraint(equalTo: datePickerContainer.bottomAnchor),
            datePicker.leadingAnchor.constraint(equalTo: datePickerContainer.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: datePickerContainer.trailingAnchor),
            datePickerContainer.widthAnchor.constraint(equalToConstant: 110)
        ])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePickerContainer)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func addTrackerButtonPressed() {
        analyticsService.report(event: "click", params: ["screen": "Main", "item": "add_track"])
        let trackerTypeVC = TrackerTypeViewController()
        trackerTypeVC.delegate = self
        present(trackerTypeVC, animated: true)
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        guard let safeActiveDate = Date.safeDate(sender.date) else { return }
        activeDate = safeActiveDate
        
        loadFilteredData()
        
        trackerCollectionView.reloadData()
    }
    
    private func setUpTitleLabel() {
        let label = UILabel()
        titleLabel = label
        
        label.text = NSLocalizedString("shared.trackerTabTitle", comment: "")
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
        
        searchBar.placeholder = NSLocalizedString("mainScreen.searchBarPlaceholder", comment: "")
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
        
        collectionView.backgroundColor = UIColor(named: "DynamicBackground")
        
        trackerCollectionView = collectionView
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.contentInset = UIEdgeInsets(top: 0, 
                                                   left: 0,
                                                   bottom: 70,
                                                   right: 0)
        
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
        emptyPlaceholderImageView = imageView
        placeholderView.addSubview(imageView)
        
        let label = UILabel()
        label.text = NSLocalizedString("mainScreen.emptyPlaceholder", comment: "")
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor(named: "YPBlack")
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        emptyPlaceholderLabel = label
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
    
    private func setUpFiltersButton() {
        let button = UIButton()
        filtersButton = button
        
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        button.backgroundColor = UIColor(named: "YPBlue")
        
        button.setTitle(NSLocalizedString("mainScreen.filtersButton", comment: ""),
                        for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(filtersButtonPressed), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            button.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            button.heightAnchor.constraint(equalToConstant: 50),
            button.widthAnchor.constraint(equalToConstant: 114)
        ])
    }
    
    @objc private func filtersButtonPressed() {
        analyticsService.report(event: "click", params: ["screen": "Main",
                                                         "item": "filter"])
        
        let filtersVC = FiltersVC(currentFilter: activeFilter)
        filtersVC.delegate = self
        let navigationVC = UINavigationController(rootViewController: filtersVC)
        present(navigationVC, animated: true)
    }
    
    private func hideEmptyPlaceholderView(_ flag: Bool) {
        emptyPlaceholderView.isHidden = flag
        filtersButton.isHidden = !flag && activeFilter == .all
        if filtersButton.isHidden {
            emptyPlaceholderImageView.image = UIImage(named: "StarPlaceholder")
            emptyPlaceholderLabel.text = NSLocalizedString(
                "mainScreen.emptyPlaceholder",
                comment: ""
            )
        } else {
            emptyPlaceholderImageView.image = UIImage(named: "NoResultsPlaceholder")
            emptyPlaceholderLabel.text = NSLocalizedString(
                "filters.emptyPlaceholder",
                comment: ""
            )
        }
    }
    
    private func presentTrackerOptionsMenuVC(trackerObject: Tracker.TrackerObject?,
                                             trackerType: String,
                                             userOperation: UserOperation) {
        let trackerOptionsMenuVC = TrackerOptionsMenuViewController(trackerObject: trackerObject,
                                                                    trackerType: trackerType,
                                                                    userOperation: userOperation)
        trackerOptionsMenuVC.delegate = self
        present(trackerOptionsMenuVC, animated: true)
    }
    
    private func loadFilteredData() {
        switch activeFilter {
        case .completed:
            _ = try? trackerRecordStore.loadCompletedTrackersForDate(activeDate)
            _ = try? trackerStore.loadTrackersForDate(
                activeDate,
                searchText: searchText,
                recordIDs: completedTrackers.map { $0.trackerID.uuidString },
                filter: .completed
            )
        case .notCompleted:
            _ = try? trackerRecordStore.loadCompletedTrackersForDate(activeDate)
            _ = try? trackerStore.loadTrackersForDate(
                activeDate,
                searchText: searchText,
                recordIDs: completedTrackers.map { $0.trackerID.uuidString },
                filter: .notCompleted
            )
        default:
            _ = try? trackerStore.loadTrackersForDate(activeDate, searchText: searchText)
            _ = try? trackerRecordStore.loadCompletedTrackersForDate(activeDate)
        }
    }
}

extension TrackersViewController: TrackerTypeViewControllerDelegate {
    func didPickTrackerType(_ trackerType: String) {
        dismiss(animated: true)
        presentTrackerOptionsMenuVC(trackerObject: nil, trackerType: trackerType, userOperation: .createTracker)
    }
}

extension TrackersViewController: TrackerOptionsMenuViewControllerDelegate {
    func didPressCancelButton() {
        trackerToEdit = nil
        dismiss(animated: true)
        trackerCollectionView.reloadData()
    }
    
    func didPressCreateButton(category: TrackerCategory, newTracker: Tracker) {
        dismiss(animated: true)
        
        try? trackerStore.addTracker(category: category, tracker: newTracker)
    }
    
    func didFinishEditing(newObject trackerObject: Tracker.TrackerObject) {
        dismiss(animated: true)
        
        if let trackerToEdit {
            try? trackerStore.updateTracker(tracker: trackerToEdit, with: trackerObject)
        }
        
        trackerToEdit = nil
    }
}

extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return trackerStore.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trackerStore.numberOfRowsInSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackerCollectionViewCell.identifier,
            for: indexPath
        ) as? TrackerCollectionViewCell
        guard let cell else { return UICollectionViewCell() }
        cell.delegate = self
        
        let tracker = trackerStore.object(at: indexPath)
        guard let tracker else { return UICollectionViewCell() }
        
        let completionStatus = completedTrackers.contains { $0.trackerID == tracker.id && $0.date == activeDate}
        
        cell.updateContent(tracker: tracker,
                           completionStatus: completionStatus,
                           dayCount: tracker.daysCompleted,
                           interaction: UIContextMenuInteraction(delegate: self))
        
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
            
            guard let headerText = trackerStore.headerForSection(indexPath.section) else {
                return UICollectionReusableView()
            }
            
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
        if let recordToDelete = completedTrackers.first(where: { $0.trackerID == tracker.id && $0.date == activeDate }) {
            try? trackerRecordStore.deleteRecord(recordToDelete)
            cell.changeCompletionStatus(to: false)
            cell.decrementDayCount()
        } else {
            let trackerRecord = TrackerRecord(id: UUID(), trackerID: tracker.id, date: activeDate)
            try? trackerRecordStore.addRecord(trackerRecord)
            cell.changeCompletionStatus(to: true)
            cell.incrementDayCount()
        }
        loadFilteredData()
    }
}

extension TrackersViewController: TrackerStoreDelegate {
    func didUpdateTrackers() {
        hideEmptyPlaceholderView(trackerStore.numberOfTrackers != 0)
        trackerCollectionView.reloadData()
    }
}

extension TrackersViewController: TrackerRecordStoreDelegate {
    func didUpdateRecords(newRecordSet: Set<TrackerRecord>) {
        completedTrackers = newRecordSet
    }
}

extension TrackersViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        reloadCollectionView()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        clearSearchBar(searchBar)
        reloadCollectionView()
    }
    
    private func reloadCollectionView() {
        trackerCollectionView.reloadData()
    }
    
    private func clearSearchBar(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.searchText = ""
        
        searchBar.endEditing(true)
        searchBar.setShowsCancelButton(false, animated: true)
    }
}

extension TrackersViewController: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction,
                                configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        guard let location = interaction.view?.convert(location, to: trackerCollectionView),
              let indexPath = trackerCollectionView.indexPathForItem(at: location)
        else { return nil }
        
        guard let tracker = trackerStore.object(at: indexPath) else { return nil }
        
        let unpinString = NSLocalizedString("mainScreen.unpin", comment: "")
        let pinString = NSLocalizedString("mainScreen.pin", comment: "")
        let editString = NSLocalizedString("mainScreen.edit", comment: "")
        let deleteString = NSLocalizedString("mainScreen.delete", comment: "")
        
        let pinActionTitle = tracker.isPinned ? unpinString : pinString
        
        let pinAction = UIAction(title: pinActionTitle) { [weak self] _ in
            self?.syncPinForTracker(tracker)
        }
        
        let editAction = UIAction(title: editString) { [weak self] _ in
            self?.initializeEditingTracker(tracker)
        }
        
        let deleteAction = UIAction(title: deleteString, attributes: .destructive) { [weak self] _ in
            self?.presentDeletionAlertForTracker(tracker)
        }
        
        return UIContextMenuConfiguration(actionProvider: { _ in
            UIMenu(children: [pinAction, editAction, deleteAction])
        })
    }
    
    private func syncPinForTracker(_ tracker: Tracker) {
        try? trackerStore.pinOrUnpinTracker(tracker: tracker)
    }
    
    private func initializeEditingTracker(_ tracker: Tracker) {
        analyticsService.report(event: "click", params: ["screen": "Main", "item": "edit"])
        let type = tracker.schedule != nil ? "New habit" : "New one-off event"
        trackerToEdit = tracker
        presentTrackerOptionsMenuVC(trackerObject: tracker.trackerObjectInstance, trackerType: type, userOperation: .editTracker)
    }
    
    private func presentDeletionAlertForTracker(_ tracker: Tracker) {
        let confirmationMessage = NSLocalizedString("mainScreen.deleteAlert.confirmationMessage", comment: "")
        let cancelActionTitle = NSLocalizedString("mainScreen.deleteAlert.cancel", comment: "")
        let deleteActionTitle = NSLocalizedString("mainScreen.deleteAlert.delete", comment: "")
        
        let alert = UIAlertController(title: nil, message: confirmationMessage, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: cancelActionTitle, style: .cancel)
        
        let deleteAction = UIAlertAction(title: deleteActionTitle, style: .destructive) { [weak self] _ in
            guard let self else { return }
            
            self.analyticsService.report(event: "click", params: ["screen": "Main", "item": "delete"])
            
            try? self.trackerStore.deleteTracker(tracker: tracker)
            
            if let recordToRemove = completedTrackers.first(where: {
                $0.date == self.activeDate && $0.trackerID == tracker.id
            }) {
                try? trackerRecordStore.deleteRecord(recordToRemove)
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        present(alert, animated: true)
    }
}

extension TrackersViewController: FiltersVCDelegate {
    func didPickFilter(_ filter: FilterOptions) {
        activeFilter = filter
        switch filter {
        case .today:
            datePicker.date = Date()
            datePickerValueChanged(datePicker)
            loadFilteredData()
        default:
            loadFilteredData()
        }
    }
}
