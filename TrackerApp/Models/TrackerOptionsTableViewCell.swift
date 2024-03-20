//
//  TrackerOptionsTableViewCell.swift
//  TrackerApp
//
//  Created by Vlad Vintenbakh on 18/3/24.
//

import UIKit

class TrackerOptionsTableViewCell: UITableViewCell {
    static let identifier = "TrackerOptionsTableViewCell"
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Category"
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = UIColor(named: "YPBlack")
        return label
    }()
    
    let actionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "ChevronIcon")
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor(named: "TextFieldGray")
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        contentView.addSubview(categoryLabel)
        contentView.addSubview(actionImageView)
        
        NSLayoutConstraint.activate([
            categoryLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            actionImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            actionImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                      constant: -16),
            actionImageView.widthAnchor.constraint(equalToConstant: 24),
            actionImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
}