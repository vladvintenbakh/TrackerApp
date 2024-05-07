//
//  StatsViewController.swift
//  TrackerApp
//
//  Created by Vlad Vintenbakh on 10/3/24.
//

import UIKit

final class StatsViewController: UIViewController {
    
    private let viewModel: StatsViewModel?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = NSLocalizedString("statsScreen.title", comment: "")
        label.textColor = UIColor(named: "YPBlack")
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textAlignment = .left
        
        return label
    }()
    
    private let placeholderImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "FaceWithTearPlaceholder"))
        return imageView
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("statsScreen.emptyPlaceholder", comment: "")
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor(named: "YPBlack")
        label.textAlignment = .center
        return label
    }()
    
    private let placeholderView: UIView = {
        let placeholderView = UIView()
        return placeholderView
    }()
    
    private let statsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        return stack
    }()
    
    private let statsCard = StatsCard(number: 0,
                                      statDescription: NSLocalizedString("stats.trackersCompleted", comment: ""))
    
    init(viewModel: StatsViewModel? = nil) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YPWhite")
        
        let placeholderSubviews = [placeholderImageView, placeholderLabel]
        placeholderSubviews.forEach { item in
            item.translatesAutoresizingMaskIntoConstraints = false
            placeholderView.addSubview(item)
        }
        
        statsStack.addArrangedSubview(statsCard)
        
        let views = [titleLabel, placeholderView, statsStack]
        views.forEach { item in
            item.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(item)
        }
        
        setUpConstraints()
        
        viewModel?.onRecordsUpdateStateChange = { [weak self] records in
            guard let self else { return }
            statsCard.setNumber(records.count)
            showEmptyPlaceholder(records.isEmpty)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.viewWillAppear()
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -105),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
            
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
            
            statsStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            statsStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            statsStack.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    private func showEmptyPlaceholder(_ flag: Bool) {
        placeholderView.isHidden = !flag
        statsStack.isHidden = flag
    }
}
