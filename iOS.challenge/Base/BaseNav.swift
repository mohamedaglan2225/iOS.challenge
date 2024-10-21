//
//  BaseNav.swift
//
//  Created by Mohamed Aglan on 18/10/2024.
//

import UIKit

class BaseNav: UINavigationController {
    
    //MARK: - Properties -
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    var appearanceBackgroundColor: UIColor { .white }
    var appearanceTintColor: UIColor { UIColor.red }
    
    //MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupGesture()
        self.handleAppearance()
        
    }
    
    //MARK: - Design -
    private func handleAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: appearanceTintColor, .font: UIFont.boldSystemFont(ofSize: 17)]
        self.navigationBar.tintColor = appearanceTintColor
        appearance.backgroundColor = appearanceBackgroundColor
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
    }
    private func setupGesture() {
        interactivePopGestureRecognizer?.delegate = self
        self.view.semanticContentAttribute = .forceLeftToRight
    }
    
}
extension BaseNav: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        self.viewControllers.count > 1
    }
}
extension UINavigationController {
    func hideHairline() {
        if let hairline = findHairlineImageViewUnder(navigationBar) {
            hairline.isHidden = true
        }
    }
    func restoreHairline() {
        if let hairline = findHairlineImageViewUnder(navigationBar) {
            hairline.isHidden = false
        }
    }
    func findHairlineImageViewUnder(_ view: UIView) -> UIImageView? {
        if view is UIImageView && view.bounds.size.height <= 1.0 {
            return view as? UIImageView
        }
        for subview in view.subviews {
            if let imageView = self.findHairlineImageViewUnder(subview) {
                return imageView
            }
        }
        return nil
    }
}

class AuthNav: BaseNav {
    
}

class ColoredNav: BaseNav {
    
    enum ApperanceType {
        case light
        case colored
        
        var appearanceBackgroundColor: UIColor {
            switch self {
            case .light:
                UIColor.white
            case .colored:
                UIColor.red
            }
        }
        var appearanceTintColor: UIColor {
            switch self {
            case .light:
                UIColor.red
            case .colored:
                UIColor.white
            }
        }
    }
    
    //MARK: - Properties -
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override var appearanceBackgroundColor: UIColor { UIColor.red }
    override var appearanceTintColor: UIColor { UIColor.white }
    
    func changeApperance(to apperanceType: ApperanceType) {
        
        UIView.animate(withDuration: 0.5) {
            
            //        let appearance = UINavigationBarAppearance()
            self.navigationBar.standardAppearance.titleTextAttributes = [.foregroundColor: apperanceType.appearanceTintColor, .font: UIFont.boldSystemFont(ofSize: 17)]
            self.navigationBar.tintColor = apperanceType.appearanceTintColor
            self.navigationBar.standardAppearance.backgroundColor = apperanceType.appearanceBackgroundColor
            //        navigationBar.standardAppearance = appearance
            //        navigationBar.scrollEdgeAppearance = appearance
            
            
            self.navigationBar.scrollEdgeAppearance?.titleTextAttributes = [.foregroundColor: apperanceType.appearanceTintColor, .font: UIFont.boldSystemFont(ofSize: 17)]
            self.navigationBar.tintColor = apperanceType.appearanceTintColor
            self.navigationBar.scrollEdgeAppearance?.backgroundColor = apperanceType.appearanceBackgroundColor
            
        }
    }
    
    
}
