//
//  CustomTableBorder.swift
//  TrackerApp
//
//  Created by Vlad Vintenbakh on 28/3/24.
//

import UIKit

class CustomSeparatorCell: UIView {
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "YPGray")
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(named: "TextFieldGray")
        
        layer.cornerRadius = 16
        layer.masksToBounds = true
        
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(separator)
        
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            separator.bottomAnchor.constraint(equalTo: bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAsFirstCell() {
        enableSeparator(true)
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    func setAsMiddleCell() {
        enableSeparator(true)
        layer.cornerRadius = 0
    }
    
    func setAsLastCell() {
        enableSeparator(false)
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    private func enableSeparator(_ flag: Bool) {
        separator.isHidden = !flag
    }
}
