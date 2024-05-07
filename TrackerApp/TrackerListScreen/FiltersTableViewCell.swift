//
//  FiltersTableViewCell.swift
//  TrackerApp
//
//  Created by Vlad Vintenbakh on 3/5/24.
//

import UIKit

final class FiltersTableViewCell: UITableViewCell {
    static let identifier = "FiltersTableViewCell"
    
    private let customSeparatorCell = CustomSeparatorCell()
    
    private let filterNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = UIColor(named: "YPBlack")
        return label
    }()
    
    private let checkMarkImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "checkmark"))
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        let views = [customSeparatorCell, filterNameLabel, checkMarkImageView]
        views.forEach { item in
            item.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(item)
        }
        
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            customSeparatorCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            customSeparatorCell.topAnchor.constraint(equalTo: contentView.topAnchor),
            customSeparatorCell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            customSeparatorCell.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            filterNameLabel.leadingAnchor.constraint(equalTo: customSeparatorCell.leadingAnchor, constant: 16),
            filterNameLabel.trailingAnchor.constraint(equalTo: customSeparatorCell.trailingAnchor, constant: -41),
            filterNameLabel.centerYAnchor.constraint(equalTo: customSeparatorCell.centerYAnchor),
            
            checkMarkImageView.trailingAnchor.constraint(equalTo: customSeparatorCell.trailingAnchor, constant: -16),
            checkMarkImageView.centerYAnchor.constraint(equalTo: filterNameLabel.centerYAnchor)
        ])
    }
    
    func setLabelText(_ text: String) {
        filterNameLabel.text = text
    }
    
    func showCheckMark(_ flag: Bool) {
        checkMarkImageView.isHidden = !flag
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
