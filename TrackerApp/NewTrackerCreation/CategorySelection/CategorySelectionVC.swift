//
//  CategorySelectionVC.swift
//  TrackerApp
//
//  Created by Vlad Vintenbakh on 14/4/24.
//

import UIKit

protocol CategorySelectionVCDelegate: AnyObject {
    func didFinishCategorySelection(category: TrackerCategory)
}

final class CategorySelectionVC: UIViewController {
    
    weak var delegate: CategorySelectionVCDelegate?
    
    private let placeholderImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "StarPlaceholder"))
        return imageView
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("categories.emptyPlaceholder", comment: "")
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor(named: "YPBlack")
        label.textAlignment = .center
        return label
    }()
    
    private let placeholderView: UIView = {
        let placeholderView = UIView()
        return placeholderView
    }()
    
    private lazy var addCategoryButton: UIButton = {
        let button = UIButton()
        
        button.backgroundColor = UIColor(named: "YPBlack")
        
        let buttonTitle = NSLocalizedString("categories.addCategoryButton", comment: "")
        button.setTitle(buttonTitle, for: .normal)
        button.setTitleColor(UIColor(named: "YPWhite"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(addCategoryButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    private let categoriesTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelection = false
        
        tableView.register(CategoriesTableViewCell.self, 
                       forCellReuseIdentifier: CategoriesTableViewCell.identifier)
        
        return tableView
    }()
    
    private let viewModel: CategorySelectionViewModel
    
    init(pickedCategory: TrackerCategory?) {
        viewModel = CategorySelectionViewModel()
        viewModel.pickedCategory = pickedCategory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "YPWhite")
        navigationItem.title = NSLocalizedString("shared.schedule", comment: "")
        
        let placeholderSubviews = [placeholderImageView, placeholderLabel]
        placeholderSubviews.forEach { item in
            item.translatesAutoresizingMaskIntoConstraints = false
            placeholderView.addSubview(item)
        }
        
        let views = [categoriesTableView, addCategoryButton, placeholderView]
        views.forEach { item in
            item.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(item)
        }
        
        setUpConstraints()
        
        viewModel.onCategoriesUpdateStateChange = { [weak self] in
            guard let self else { return }
            self.showPlaceholderView(viewModel.categories.isEmpty)
            self.categoriesTableView.reloadData()
        }
        
        viewModel.onCategorySelectionStateChange = { [weak self] category in
            guard let self else { return }
            self.delegate?.didFinishCategorySelection(category: category)
        }
        
        viewModel.loadCategoriesFromStorage()
        
        categoriesTableView.dataSource = self
        categoriesTableView.delegate = self
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            placeholderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            placeholderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            placeholderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            placeholderImageView.centerXAnchor.constraint(equalTo: placeholderView.centerXAnchor),
            placeholderImageView.centerYAnchor.constraint(equalTo: placeholderView.centerYAnchor),
            placeholderImageView.heightAnchor.constraint(equalToConstant: 80),
            placeholderImageView.widthAnchor.constraint(equalToConstant: 80),
            
            placeholderLabel.topAnchor.constraint(equalTo: placeholderImageView.bottomAnchor, constant: 8),
            placeholderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            placeholderLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60),
            
            categoriesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoriesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoriesTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            categoriesTableView.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor, constant: -16),
        ])
    }
    
    @objc private func addCategoryButtonPressed() {
        let categoryCreationVC = CategoryCreationVC()
        categoryCreationVC.delegate = self
        
        let navigationVC = UINavigationController(rootViewController: categoryCreationVC)
        present(navigationVC, animated: true)
    }
    
    private func showPlaceholderView(_ flag: Bool) {
        placeholderView.isHidden = !flag
    }
}

extension CategorySelectionVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: CategoriesTableViewCell.identifier,
            for: indexPath
        ) as? CategoriesTableViewCell
        guard let cell else { return UITableViewCell() }
        
        let currentRow = indexPath.row
        let category = viewModel.categories[currentRow]
        let numCategories = viewModel.categories.count
        
        var cellType = "Middle"
        
        if currentRow == 0 {
            cellType = numCategories == 1 ? "None" : "First"
        } else if currentRow == numCategories - 1 {
            cellType = "Last"
        }
        
        cell.setLabelText(category.title)
        cell.showCheckMark(viewModel.pickedCategory == category)
        cell.configCustomCell(cellType: cellType)
        
        return cell
    }
}

extension CategorySelectionVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return viewModel.setPickedCategory(position: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView,
                   contextMenuConfigurationForRowAt indexPath: IndexPath,
                   point: CGPoint) -> UIContextMenuConfiguration? {
        
        let currentRow = indexPath.row
        let category = viewModel.categories[currentRow]
        
        let editActionTitle = NSLocalizedString("categories.editAction", comment: "")
        let editAction = UIAction(title: editActionTitle, handler: { [weak self] _ in
            self?.contextMenuEdit(item: category)
        })
        
        let deleteActionTitle = NSLocalizedString("categories.deleteAction", comment: "")
        let deleteAction = UIAction(
            title: deleteActionTitle,
            attributes: .destructive,
            handler: { [weak self] _ in
                self?.contextMenuDelete(item: category)
            }
        )
        
        return UIContextMenuConfiguration(actionProvider: { _ in UIMenu(children: [editAction, deleteAction]) })
    }
    
    private func contextMenuEdit(item category: TrackerCategory) {
        let categoryObject = TrackerCategory.CategoryObject(id: category.id, title: category.title)
        
        let categoryCreationVC = CategoryCreationVC(categoryObject: categoryObject)
        categoryCreationVC.delegate = self
        
        let navigationVC = UINavigationController(rootViewController: categoryCreationVC)
        present(navigationVC, animated: true)
    }
    
    private func contextMenuDelete(item category: TrackerCategory) {
        let alertFormatString = NSLocalizedString("categories.deleteAlertText", comment: "")
        let alertMessage = String(format: alertFormatString, category.title)
        let alert = UIAlertController(title: nil,
                                      message: alertMessage,
                                      preferredStyle: .actionSheet)
        
        let deleteActionTitle = NSLocalizedString("categories.deleteAction", comment: "")
        let deleteAction = UIAlertAction(
            title: deleteActionTitle,
            style: .destructive,
            handler: { [weak self] _ in
                self?.viewModel.deleteCategory(category)
            }
        )
        alert.addAction(deleteAction)
        
        let cancelActionTitle = NSLocalizedString("categories.cancelAction", comment: "")
        let cancelAction = UIAlertAction(title: cancelActionTitle, style: .cancel)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}

extension CategorySelectionVC: CategoryCreationVCDelegate {
    func didCreateCategory(categoryObject: TrackerCategory.CategoryObject) {
        dismiss(animated: true)
        viewModel.createCategory(categoryObject: categoryObject)
    }
}
