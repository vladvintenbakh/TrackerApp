//
//  WeekdaysTableViewCell.swift
//  TrackerApp
//
//  Created by Vlad Vintenbakh on 24/3/24.
//

import UIKit

protocol WeekdayTableViewCellDelegate: AnyObject {
    func didToggleSwitch(for day: Weekday, to flag: Bool)
}

class WeekdayTableViewCell: UITableViewCell {
    static let identifier = "WeekdaysTableViewCell"
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = UIColor(named: "YPBlack")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var onOffSwitch: UISwitch = {
        let switchView = UISwitch()
        switchView.onTintColor = .blue
        switchView.translatesAutoresizingMaskIntoConstraints = false
        
        switchView.addTarget(self, action: #selector(changedSwitchValue), for: .valueChanged)
        return switchView
    }()
    
    weak var delegate: WeekdayTableViewCellDelegate?
    
    private var weekday: Weekday?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.addSubview(dayLabel)
        contentView.addSubview(onOffSwitch)
        
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dayLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -83),
            dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            onOffSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            onOffSwitch.centerYAnchor.constraint(equalTo: dayLabel.centerYAnchor)
        ])
    }
    
    func setWeekday(_ weekday: Weekday, to flag: Bool) {
        dayLabel.text = weekday.rawValue
        onOffSwitch.isOn = flag
        
        self.weekday = weekday
    }
    
    @objc private func changedSwitchValue(_ sender: UISwitch) {
        guard let weekday else { return }
        let flag = sender.isOn
        delegate?.didToggleSwitch(for: weekday, to: flag)
    }
}
