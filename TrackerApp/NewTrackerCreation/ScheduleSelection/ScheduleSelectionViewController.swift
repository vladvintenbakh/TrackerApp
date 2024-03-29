//
//  ScheduleSelectionViewController.swift
//  TrackerApp
//
//  Created by Vlad Vintenbakh on 24/3/24.
//

import UIKit

protocol ScheduleSelectionViewControllerDelegate: AnyObject {
    func didSelectWeekdays(_ weekdays: [Weekday])
}

class ScheduleSelectionViewController: UIViewController {
    
    private let weekdayTableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.layer.cornerRadius = 16
        table.layer.masksToBounds = true
        
        table.translatesAutoresizingMaskIntoConstraints = false
        
        table.register(WeekdayTableViewCell.self,
                       forCellReuseIdentifier: WeekdayTableViewCell.identifier)
        
        return table
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "YPBlack")
        
        button.setTitle("Done", for: .normal)
        button.setTitleColor(UIColor(named: "YPWhite"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(pressedDoneButton), for: .touchUpInside)
        
        return button
    }()

    weak var delegate: ScheduleSelectionViewControllerDelegate?
    
    private var selectedWeekdaySet: Set<Weekday> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YPWhite")
        
        navigationItem.title = "Schedule"
        
        view.addSubview(weekdayTableView)
        view.addSubview(doneButton)
        
        weekdayTableView.dataSource = self
        weekdayTableView.delegate = self
        
        setUpConstraints()
    }
    
    init(selectedWeekdaySet: Set<Weekday>) {
        self.selectedWeekdaySet = selectedWeekdaySet
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpConstraints() {
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            weekdayTableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 16),
            weekdayTableView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -16),
            weekdayTableView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 16),
            
            doneButton.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.topAnchor.constraint(equalTo: weekdayTableView.bottomAnchor, constant: 47),
            doneButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    @objc private func pressedDoneButton() {
        let weekdayArray = Array(selectedWeekdaySet)
        delegate?.didSelectWeekdays(weekdayArray.sorted())
    }
}

extension ScheduleSelectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: WeekdayTableViewCell.identifier,
            for: indexPath
        ) as? WeekdayTableViewCell
        guard let cell else { return UITableViewCell() }
        
        let currentRow = indexPath.row
        let currentWeekday = Weekday.allCases[currentRow]
        let flag = selectedWeekdaySet.contains(currentWeekday)
        cell.setWeekday(currentWeekday, to: flag)
        
        var cellType: String = "Middle"
        if currentRow == 0 {
            cellType = "First"
        } else if currentRow == Weekday.allCases.count - 1 {
            cellType = "Last"
        }
        cell.configCustomCell(cellType: cellType)
        
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

extension ScheduleSelectionViewController: UITableViewDelegate {
    
}

extension ScheduleSelectionViewController: WeekdayTableViewCellDelegate {
    func didToggleSwitch(for day: Weekday, to flag: Bool) {
        if flag {
            selectedWeekdaySet.insert(day)
        } else {
            selectedWeekdaySet.remove(day)
        }
    }
}
