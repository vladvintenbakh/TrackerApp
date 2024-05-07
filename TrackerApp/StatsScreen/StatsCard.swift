//
//  StatsCard.swift
//  TrackerApp
//
//  Created by Vlad Vintenbakh on 26/4/24.
//

import UIKit

final class StatsCard: UIView {
    
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textColor = UIColor(named: "YPBlack")
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor(named: "YPBlack")
        return label
    }()
    
    private var number: Int {
        didSet {
            numberLabel.text = "\(number)"
        }
    }
    
    private var statDescription: String {
        didSet {
            descriptionLabel.text = statDescription
        }
    }
    
    init(number: Int, statDescription: String) {
        self.number = -1
        self.statDescription = ""
        super.init(frame: .zero)
        
        setNumber(number)
        setStatDescription(statDescription)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        let subviews = [numberLabel, descriptionLabel]
        subviews.forEach { item in
            item.translatesAutoresizingMaskIntoConstraints = false
            addSubview(item)
        }
        
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addGradientBorder(startPoint: CGPoint(x: 1.0, y: 0.5),
                          endPoint: CGPoint(x: 0.0, y: 0.5),
                          width: 1,
                          gradientColors: [.blue, .green, .red],
                          cornerRadius: 12)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            numberLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            numberLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            numberLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            descriptionLabel.topAnchor.constraint(equalTo: numberLabel.bottomAnchor, constant: 7),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
        ])
    }
    
    func setNumber(_ number: Int) {
        self.number = number
    }
    
    func setStatDescription(_ statDescription: String) {
        self.statDescription = statDescription
    }
}
