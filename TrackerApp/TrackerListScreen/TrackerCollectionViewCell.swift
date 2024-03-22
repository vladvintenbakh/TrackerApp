//
//  TrackerCollectionViewCell.swift
//  TrackerApp
//
//  Created by Vlad Vintenbakh on 22/3/24.
//

import UIKit

class TrackerCollectionViewCell: UICollectionViewCell {
    static let identifier = "TrackerCollectionViewCell"
    
    private let selectedEmoji: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emojiBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 68
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
    
    private let markCompletedButton: UIButton = {
        let button = UIButton(type: .custom)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.tintColor = .systemYellow
        button.setImage(UIImage(named: "plus"), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(selectedEmoji)
        contentView.addSubview(emojiBackgroundView)
        contentView.addSubview(trackerNameLabel)
        contentView.addSubview(topContainerView)
        contentView.addSubview(numDaysLabel)
        contentView.addSubview(markCompletedButton)
        
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
}
