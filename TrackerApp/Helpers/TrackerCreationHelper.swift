//
//  TrackerCreationHelper.swift
//  TrackerApp
//
//  Created by Vlad Vintenbakh on 18/3/24.
//

import UIKit

class TrackerCreationHelper {
    
    func createPageScrollView(view: UIView) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: guide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: guide.bottomAnchor)
        ])
        
        return scrollView
    }
    
    func createMainContentView(view: UIScrollView) -> UIView {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentView)
        
        let guide = view.contentLayoutGuide
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: guide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            
            contentView.widthAnchor.constraint(equalTo: view.frameLayoutGuide.widthAnchor)
        ])
        
        return contentView
    }
    
    func createTitleLabel(view: UIView, text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = text
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor(named: "YPBlack")
        label.textAlignment = .center
        view.addSubview(label)
    
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 27)
        ])
        
        return label
    }
    
    func createTrackerNameTextField(view: UIView) -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        textField.placeholder = "Enter tracker name"
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        textField.backgroundColor = UIColor(named: "TextFieldGray")
        
        let paddingView = UIView(frame: CGRect(x: 0,
                                               y: 0,
                                               width: 16,
                                               height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        view.addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                               constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 75)
        ])
        
        return textField
    }
    
    func createTrackerOptionsTableView(view: UIView, height: CGFloat) -> UITableView {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                               constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: height)
        ])
        
        tableView.register(TrackerOptionsTableViewCell.self,
                           forCellReuseIdentifier: TrackerOptionsTableViewCell.identifier)
        
        return tableView
    }
    
    func createCollectionView(view: UIView) -> UICollectionView {
        let collection = UICollectionView(frame: .zero,
                                          collectionViewLayout: UICollectionViewFlowLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        
//        collection.backgroundColor = .systemYellow // REMOVE THIS LATER
        
        view.addSubview(collection)
        
        NSLayoutConstraint.activate([
            collection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collection.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        return collection
    }
    
    func createActionButton(text: String) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        return button
    }
}
