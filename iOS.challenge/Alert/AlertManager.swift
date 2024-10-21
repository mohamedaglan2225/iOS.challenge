//
//  AlertManger.swift
//  App
//
//  Created by Mohamed Aglan on 18/10/2024.
//

import UIKit

class AlertManager {
    
    //MARK: - Properties -
    private let topAlert: TopAlert = TopAlert()
    static let shared: AlertManager = AlertManager()
    private var isLongPressActive: Bool = false
    private var isSwipePerformed: Bool = false
    private var timer: Timer?
    
    //MARK: - Initializer -
    private init() {
        self.setupSwipes()
    }
    
    //MARK: - Design -
    private func setupTopViewConstraint() {
        guard let window = SceneDelegate.current?.window else {return}
        window.addSubview(self.topAlert)
        self.topAlert.translatesAutoresizingMaskIntoConstraints = false
        self.topAlert.topAnchor.constraint(equalTo: window.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        self.topAlert.leadingAnchor.constraint(equalTo: window.safeAreaLayoutGuide.leadingAnchor, constant: 12).isActive = true
        self.topAlert.trailingAnchor.constraint(equalTo: window.safeAreaLayoutGuide.trailingAnchor, constant: -12).isActive = true
    }
    private func setupSwipes() {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeUp.direction = .up
        self.topAlert.addGestureRecognizer(swipeUp)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
        self.topAlert.addGestureRecognizer(longPressRecognizer)
    }
    
    //MARK: - Properties -
    func show(message: String, type: TopAlert.AlertType) {
        self.topAlert.set(message: message, type: type)
        self.setupTopViewConstraint()
        self.topAlert.transform = .init(translationX: 0, y: -200)
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        UIView.animate(withDuration: 0.6) {
            self.topAlert.transform = .identity
        }
        self.timer?.invalidate()
        self.timer = nil
        self.timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { [weak self] _ in
            guard let self = self else {return}
            if !self.isLongPressActive, !self.isSwipePerformed {
                self.removeAnimate()
            }
        }
    }
    
    //MARK: - Animations -
    private func removeAnimate(){
        UIView.animate(withDuration: 0.4) {
            self.topAlert.transform = .init(translationX: 0, y: -200)
        } completion: { _  in
                self.isLongPressActive = false
                self.isSwipePerformed = false
                self.topAlert.removeFromSuperview()
        }
    }
    
    //MARK: - Actions -
    @objc private func longPressed(sender: UILongPressGestureRecognizer) {
        self.isLongPressActive = true
        if sender.state == UIGestureRecognizer.State.ended {
            self.removeAnimate()
        }
    }
    @objc private func handleGesture(gesture: UISwipeGestureRecognizer) {
        self.isSwipePerformed = true
        if gesture.direction == .up || gesture.direction == .down {
            self.removeAnimate()
        }
    }
    
}

