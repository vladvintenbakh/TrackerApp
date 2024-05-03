//
//  FiltersVC.swift
//  TrackerApp
//
//  Created by Vlad Vintenbakh on 3/5/24.
//

import UIKit

protocol FiltersVCDelegate: AnyObject {
    func didPickFilter(_ filter: FilterOptions)
}

final class FiltersVC: UIViewController {
    weak var delegate: FiltersVCDelegate?
    
    private let filterOptions: [FilterOptions] = [.all, .today, .completed, .notCompleted]
    
    private var currentFilter: FilterOptions
    
    private let filterNames = [
        NSLocalizedString("filters.allTrackers", comment: ""),
        NSLocalizedString("filters.trackersForToday", comment: ""),
        NSLocalizedString("filters.completed", comment: ""),
        NSLocalizedString("filters.notCompleted", comment: ""),
    ]
    
    private let filtersTableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.allowsMultipleSelection = false
        
        table.layer.cornerRadius = 16
        table.layer.masksToBounds = true
        
        table.register(FiltersTableViewCell.self,
                       forCellReuseIdentifier: FiltersTableViewCell.identifier)
        
        return table
    }()
    
    init(currentFilter: FilterOptions) {
        self.currentFilter = currentFilter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YPWhite")
        title = NSLocalizedString("filters.title", comment: "")
        
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor(named: "YPBlack") ?? .black,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium)
        ]
        
        filtersTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filtersTableView)
        
        filtersTableView.dataSource = self
        filtersTableView.delegate = self
        
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            filtersTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            filtersTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            filtersTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            filtersTableView.heightAnchor.constraint(equalToConstant: CGFloat(filterNames.count) * 75.0)
        ])
    }
}

extension FiltersVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: FiltersTableViewCell.identifier,
            for: indexPath
        ) as? FiltersTableViewCell
        guard let cell else { return UITableViewCell() }
        
        let filter = filterOptions[indexPath.row]
        let filterName = filterNames[indexPath.row]
        
        var cellType = "Middle"
        
        if indexPath.row == 0 {
            cellType = "First"
        } else if indexPath.row == filterNames.count - 1 {
            cellType = "Last"
        }
        
        cell.setLabelText(filterName)
        cell.showCheckMark(filter == currentFilter)
        cell.configCustomCell(cellType: cellType)
        
        return cell
    }
}

extension FiltersVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true)
        currentFilter = filterOptions[indexPath.row]
        delegate?.didPickFilter(currentFilter)
        filtersTableView.reloadData()
    }
}
