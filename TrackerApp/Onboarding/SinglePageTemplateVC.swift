//
//  SinglePageTemplate.swift
//  TrackerApp
//
//  Created by Vlad Vintenbakh on 10/4/24.
//

import UIKit

enum BackgroundImage {
    case firstPage
    case secondPage
}

enum InfoLabelText {
    case firstPage
    case secondPage
}

final class SinglePageTemplateVC: UIViewController {
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.textColor = UIColor(named: "YPBlack")
        label.numberOfLines = 0
        return label
    }()
    
    private let backgroundImage: BackgroundImage
    private let infoLabelText: InfoLabelText
    
    init(backgroundImage: BackgroundImage, infoLabelText: InfoLabelText) {
        self.backgroundImage = backgroundImage
        self.infoLabelText = infoLabelText
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let views = [backgroundImageView, infoLabel]
        views.forEach { item in
            item.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(item)
        }
        
        configureUI()
        setUpConstraints()
    }
    
    private func configureUI() {
        switch backgroundImage {
        case .firstPage:
            backgroundImageView.image = UIImage(named: "OnboardingImageOne")
        case .secondPage:
            backgroundImageView.image = UIImage(named: "OnboardingImageTwo")
        }
        
        switch infoLabelText {
        case .firstPage:
            infoLabel.text = "Track absolutely anything"
        case .secondPage:
            infoLabel.text = "And not just healthy stuff like exercise"
        }
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            infoLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -270)
        ])
    }
}
