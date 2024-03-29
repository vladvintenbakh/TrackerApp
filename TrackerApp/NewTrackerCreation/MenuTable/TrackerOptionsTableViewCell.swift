//
//  TrackerOptionsTableViewCell.swift
//  TrackerApp
//
//  Created by Vlad Vintenbakh on 18/3/24.
//

import UIKit

class TrackerOptionsTableViewCell: UITableViewCell {
    static let identifier = "TrackerOptionsTableViewCell"
    
    private let customSeparatorCell = CustomSeparatorCell()
    
    private let cellLabel: UILabel = {
        let label = UILabel()
        label.text = "Category"
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = UIColor(named: "YPBlack")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let selectedValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = UIColor(named: "YPGray")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let actionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "ChevronIcon")
        return imageView
    }()
    
    private let labelValueStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor(named: "TextFieldGray")
        selectionStyle = .none
        
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        labelValueStack.addArrangedSubview(cellLabel)
        labelValueStack.addArrangedSubview(selectedValueLabel)
        
        contentView.addSubview(customSeparatorCell)
        contentView.addSubview(labelValueStack)
        contentView.addSubview(actionImageView)
        
        NSLayoutConstraint.activate([
            customSeparatorCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            customSeparatorCell.topAnchor.constraint(equalTo: contentView.topAnchor),
            customSeparatorCell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            customSeparatorCell.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            labelValueStack.leadingAnchor.constraint(equalTo: customSeparatorCell.leadingAnchor,
                                                     constant: 16),
            labelValueStack.trailingAnchor.constraint(equalTo: customSeparatorCell.trailingAnchor,
                                                      constant: -56),
            labelValueStack.centerYAnchor.constraint(equalTo: customSeparatorCell.centerYAnchor),
            
            actionImageView.centerYAnchor.constraint(equalTo: customSeparatorCell.centerYAnchor),
            actionImageView.trailingAnchor.constraint(equalTo: customSeparatorCell.trailingAnchor,
                                                      constant: -16),
            actionImageView.widthAnchor.constraint(equalToConstant: 24),
            actionImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func setLabelText(_ text: String) {
        cellLabel.text = text
    }
    
    func setValue(_ text: String) {
        selectedValueLabel.text = text
    }
    
    func configCustomCell(cellType: String) {
        switch cellType {
        case "First":
            customSeparatorCell.setAsFirstCell()
        case "Middle":
            customSeparatorCell.setAsMiddleCell()
        case "Last":
            customSeparatorCell.setAsLastCell()
        default:
            return
        }
    }
}
