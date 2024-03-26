//
//  TrackerCollectionViewCell.swift
//  TrackerApp
//
//  Created by Vlad Vintenbakh on 22/3/24.
//

import UIKit

protocol TrackerCollectionViewCellDelegate: AnyObject {
    func didMarkDayCompleted(for tracker: Tracker, cell: TrackerCollectionViewCell)
}

class TrackerCollectionViewCell: UICollectionViewCell {
    static let identifier = "TrackerCollectionViewCell"
    
    private let selectedEmoji: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emojiBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "YPWhite")?.withAlphaComponent(0.3)
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let trackerNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor(named: "YPWhite")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let topContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(named: "TrackerCellBorder")?.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let numDaysLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var markCompletedButton: UIButton = {
        let button = UIButton()
        button.tintColor = UIColor(named: "YPWhite")
        button.setImage(UIImage(named: "plus"), for: .normal)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(pressedMarkCompletedButton), for: .touchUpInside)
        
        return button
    }()
    
    private var currentTracker: Tracker?
    private var dayCount = 0 {
        willSet {
            numDaysLabel.text = "\(newValue) day(s)"
        }
    }
    
    weak var delegate: TrackerCollectionViewCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(topContainerView)
        contentView.addSubview(emojiBackgroundView)
        contentView.addSubview(selectedEmoji)
        contentView.addSubview(trackerNameLabel)
        contentView.addSubview(numDaysLabel)
        contentView.addSubview(markCompletedButton)
        
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        markCompletedButton.setImage(UIImage(systemName: "plus"), for: .normal)
        markCompletedButton.layer.opacity = 1
        
        currentTracker = nil
        dayCount = 0
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            topContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            topContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            topContainerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            topContainerView.heightAnchor.constraint(equalToConstant: 90),
            
            emojiBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                         constant: 12),
            emojiBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                                     constant: 12),
            emojiBackgroundView.heightAnchor.constraint(equalToConstant: 24),
            emojiBackgroundView.widthAnchor.constraint(equalToConstant: 24),
            
            selectedEmoji.centerXAnchor.constraint(equalTo: emojiBackgroundView.centerXAnchor),
            selectedEmoji.centerYAnchor.constraint(equalTo: emojiBackgroundView.centerYAnchor),
            
            trackerNameLabel.leadingAnchor.constraint(equalTo: topContainerView.leadingAnchor,
                                                      constant: 12),
            trackerNameLabel.trailingAnchor.constraint(equalTo: topContainerView.trailingAnchor,
                                                       constant: -12),
            trackerNameLabel.bottomAnchor.constraint(equalTo: topContainerView.bottomAnchor,
                                                     constant: -12),
            
            numDaysLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            numDaysLabel.topAnchor.constraint(equalTo: topContainerView.bottomAnchor, constant: 16),
            
            markCompletedButton.leadingAnchor.constraint(equalTo: numDaysLabel.trailingAnchor,
                                                         constant: 8),
            markCompletedButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                          constant: -12),
            markCompletedButton.centerYAnchor.constraint(equalTo: numDaysLabel.centerYAnchor),
            markCompletedButton.widthAnchor.constraint(equalToConstant: 34),
            markCompletedButton.heightAnchor.constraint(equalToConstant: 34)
        ])
    }
    
    func incrementDayCount() {
        dayCount += 1
    }
    
    func decrementDayCount() {
        dayCount -= 1
    }
    
    func updateContent(tracker: Tracker, completionStatus: Bool, dayCount: Int) {
        self.currentTracker = tracker
        self.dayCount = dayCount
        
        updateUI(color: tracker.color, emoji: tracker.emoji, name: tracker.name)
        changeCompletionStatus(to: completionStatus)
    }
    
    private func updateUI(color: UIColor, emoji: String, name: String) {
        topContainerView.backgroundColor = color
        markCompletedButton.backgroundColor = color
        selectedEmoji.text = emoji
        trackerNameLabel.text = name
    }
    
    func changeCompletionStatus(to completionStatus: Bool) {
        let image = completionStatus ? UIImage(systemName: "checkmark") : UIImage(systemName: "plus")
        let opacity: Float = completionStatus ? 0.3 : 1.0
        
        markCompletedButton.setImage(image, for: .normal)
        markCompletedButton.layer.opacity = opacity
    }
    
    @objc private func pressedMarkCompletedButton() {
        guard let currentTracker else { return }
        delegate?.didMarkDayCompleted(for: currentTracker, cell: self)
    }
}
