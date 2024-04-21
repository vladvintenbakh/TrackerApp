//
//  CategoryCreationVC.swift
//  TrackerApp
//
//  Created by Vlad Vintenbakh on 14/4/24.
//

import UIKit

protocol CategoryCreationVCDelegate: AnyObject {
    func didCreateCategory(categoryObject: TrackerCategory.CategoryObject)
}

final class CategoryCreationVC: UIViewController {
    
    weak var delegate: CategoryCreationVCDelegate?
    
    private lazy var categoryNameTextField: UITextField = {
        let textField = UITextField()
        
        textField.placeholder = NSLocalizedString(
            "categoryCreation.textFieldPlaceholder",
            comment: ""
        )
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        textField.backgroundColor = UIColor(named: "TextFieldGray")
        
        let paddingView = UIView(frame: CGRect(x: 0,
                                               y: 0,
                                               width: 16,
                                               height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        textField.addTarget(self, action: #selector(editedTextField), for: .editingChanged)
        
        return textField
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        
        button.backgroundColor = UIColor(named: "YPGray")
        button.isEnabled = false
        
        let buttonTitle = NSLocalizedString("shared.doneButton", comment: "")
        button.setTitle(buttonTitle, for: .normal)
        button.setTitleColor(UIColor(named: "YPWhite"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    private var categoryObject: TrackerCategory.CategoryObject
    
    private var isDoneButtonActive = false {
        willSet {
            toggleDoneButton(to: newValue)
        }
    }
    
    init(categoryObject: TrackerCategory.CategoryObject) {
        self.categoryObject = categoryObject
        super.init(nibName: nil, bundle: nil)
        updateUI()
    }
    
    init() {
        let emptyCategory = TrackerCategory.CategoryObject(id: UUID(), title: "")
        self.categoryObject = emptyCategory
        super.init(nibName: nil, bundle: nil)
        updateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        navigationItem.title = NSLocalizedString("categoryCreation.title", comment: "")
        view.backgroundColor = UIColor(named: "YPWhite")
        
        let views = [categoryNameTextField, doneButton]
        views.forEach { item in
            item.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(item)
        }
        
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            categoryNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoryNameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            categoryNameTextField.heightAnchor.constraint(equalToConstant: 75),
            
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func doneButtonPressed() {
        delegate?.didCreateCategory(categoryObject: categoryObject)
    }
    
    @objc private func editedTextField(_ sender: UITextField) {
        guard let title = sender.text else {
            isDoneButtonActive = false
            return
        }
        
        isDoneButtonActive = !title.isEmpty
        if isDoneButtonActive {
            categoryObject.title = title
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func updateUI() {
        categoryNameTextField.text = categoryObject.title
    }
    
    private func toggleDoneButton(to flag: Bool) {
        doneButton.isEnabled = flag
        doneButton.backgroundColor = flag ? UIColor(named: "YPBlack") : UIColor(named: "YPGray")
    }
}
