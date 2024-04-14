//
//  CategorySelectionVC.swift
//  TrackerApp
//
//  Created by Vlad Vintenbakh on 14/4/24.
//

import UIKit

final class CategorySelectionVC: UIViewController {
    private let placeholderImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "StarPlaceholder"))
        return imageView
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Group habits/events into categories"
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
        
        button.setTitle("Add a new category", for: .normal)
        button.setTitleColor(UIColor(named: "YPWhite"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(addCategoryButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "YPWhite")
        navigationItem.title = "Category"
        
        let placeholderSubviews = [placeholderImageView, placeholderLabel]
        placeholderSubviews.forEach { item in
            item.translatesAutoresizingMaskIntoConstraints = false
            placeholderView.addSubview(item)
        }
        
        let views = [placeholderView, addCategoryButton]
        views.forEach { item in
            item.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(item)
        }
        
        setUpConstraints()
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
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func addCategoryButtonPressed() {
        
    }
}
