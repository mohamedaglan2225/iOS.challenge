//
//  ConnectionAlertManager.swift
//  App
//
//  Created by Mohamed Aglan on 18/10/2024.
//

import UIKit

class ConnectionAlertManager {
    
    //MARK: - Properties -
    private let bottomAlert: TopAlert = TopAlert()
    static let shared: ConnectionAlertManager = ConnectionAlertManager()
    
    //MARK: - Initializer -
    private init() {}
    
    //MARK: - Design -
    private func setupTopViewConstraint() {
        guard let window = SceneDelegate.current?.window else {return}
        window.addSubview(self.bottomAlert)
        self.bottomAlert.translatesAutoresizingMaskIntoConstraints = false
        self.bottomAlert.bottomAnchor.constraint(equalTo: window.safeAreaLayoutGuide.bottomAnchor, constant: -55).isActive = true
        self.bottomAlert.leadingAnchor.constraint(equalTo: window.safeAreaLayoutGuide.leadingAnchor, constant: 12).isActive = true
        self.bottomAlert.trailingAnchor.constraint(equalTo: window.safeAreaLayoutGuide.trailingAnchor, constant: -12).isActive = true
    }
    
    //MARK: - Properties -
    func showConnectionLost() {
        let image = UIImage(systemName: "wifi.exclamationmark")?.withTintColor(.secondaryLabel, renderingMode: .alwaysOriginal)
        ConnectionAlertManager.shared.show(
            message: "Application_Not_connected_To_Internet",
            type: .image(image),
            isFixed: true
        )
    }
    func showConnectionRestored() {
        ConnectionAlertManager.shared.show(
            message: "Internet_Connection_Restored",
            type: .image(.init(systemName: "wifi")),
            isFixed: false
        )
    }
    
    //MARK: - Animations -
    private func show(message: String, type: TopAlert.AlertType, isFixed: Bool) {
        self.bottomAlert.set(message: message, type: type)
        self.setupTopViewConstraint()
        self.bottomAlert.transform = .init(translationX: 0, y: 200)
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        UIView.animate(withDuration: 0.6) {
            self.bottomAlert.transform = .identity
        }
        if !isFixed {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.removeAnimate()
            }
        }
    }
    private func removeAnimate(){
        UIView.animate(withDuration: 0.4) {
            self.bottomAlert.transform = .init(translationX: 0, y: 200)
        } completion: { _  in
            self.bottomAlert.removeFromSuperview()
        }
    }
    
}
