//
//  TrackerCreationHelper.swift
//  TrackerApp
//
//  Created by Vlad Vintenbakh on 18/3/24.
//

import UIKit

class TrackerCreationHelper {
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
            label.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27)
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
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                               constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
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
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                               constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: height)
        ])
        
        return tableView
    }
    
    func createCollectionLabel(view: UIView, text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = text
        label.textColor = UIColor(named: "YPBlack")
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                           constant: 28)
        ])
        
        return label
    }
    
    func createCollectionView(view: UIView) -> UICollectionView {
        let collection = UICollectionView(frame: .zero,
                                          collectionViewLayout: UICollectionViewFlowLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        
        collection.backgroundColor = .systemYellow // REMOVE THIS LATER
        
        view.addSubview(collection)
        
        NSLayoutConstraint.activate([
            collection.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collection.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
//            collection.heightAnchor.constraint(equalToConstant: 100) // REMOVE THIS LATER
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
