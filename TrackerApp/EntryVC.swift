//
//  EntryVC.swift
//  TrackerApp
//
//  Created by Vlad Vintenbakh on 12/4/24.
//

import UIKit

final class EntryVC: UIViewController, OnboardingDelegate {
    private lazy var tabBarVC = TabBarController()
    private lazy var onboardingVC = OnboardingPageVC(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal
    )
    
    private let userDefaults = UserDefaults.standard
    private let storageKey = "isOnboardingSkipped"
    
    private var isOnboardingSkipped: Bool {
        get {
            userDefaults.bool(forKey: storageKey)
        }
        set {
            userDefaults.setValue(newValue, forKey: storageKey)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        onboardingVC.onboardingDelegate = self
        
        if !isOnboardingSkipped {
            addChildVC(onboardingVC)
        } else {
            addChildVC(tabBarVC)
        }
    }
    
    func didFinishOnboarding() {
        isOnboardingSkipped = true
        removeChildVC(onboardingVC)
        addChildVC(tabBarVC)
    }
    
    private func addChildVC(_ childVC: UIViewController) {
        addChild(childVC)
        view.addSubview(childVC.view)
        
        if let childView = childVC.view {
            childView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                childView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                childView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                childView.topAnchor.constraint(equalTo: view.topAnchor),
                childView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
        
        childVC.didMove(toParent: self)
    }
    
    private func removeChildVC(_ childVC: UIViewController) {
        childVC.willMove(toParent: nil)
        childVC.view.removeFromSuperview()
        childVC.removeFromParent()
    }
}
