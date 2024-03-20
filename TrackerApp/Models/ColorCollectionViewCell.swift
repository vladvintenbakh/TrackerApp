//
//  ColorCollectionViewCell.swift
//  TrackerApp
//
//  Created by Vlad Vintenbakh on 20/3/24.
//

import UIKit

class ColorCollectionViewCell: UICollectionViewCell {
    static let identifier = "ColorCollectionViewCell"
    
    private let colorTile: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.addSubview(colorTile)
        
        NSLayoutConstraint.activate([
            colorTile.heightAnchor.constraint(equalToConstant: 40),
            colorTile.widthAnchor.constraint(equalToConstant: 40),
            colorTile.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorTile.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
