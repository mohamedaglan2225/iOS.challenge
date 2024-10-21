//
//  BaseViewController.swift
//  App
//
//  Created by Mohamed Aglan on 18/10/2024.
//

import UIKit

class BaseViewController: UIViewController {
    
    //MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    
    //MARK: - Design -
    func addBackButtonWith(title: String, titleColor: UIColor?) {
        let button = UIButton()
        button.setImage(UIImage(named: "chevron.forward"), for: .normal)
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.textColor = titleColor
        button.isUserInteractionEnabled = false
        let stack = UIStackView.init(arrangedSubviews: [button, titleLabel])
        stack.axis = .horizontal
        stack.spacing = 8
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.backButtonPressed))
        stack.addGestureRecognizer(tap)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: stack)
    }
    
    func setLeading(title: String?, textColor: UIColor?) {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.textColor = textColor
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
    }
    
    //MARK: - Actions -
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Deinit -
    deinit {
        print("\(self.className) is deinit, No memory leak found")
    }
    
}

extension BaseViewController {
    func showIndicator() {
        LoaderManager.shared.show()
    }
    func hideIndicator() {
        LoaderManager.shared.hide()
    }
}

extension BaseViewController {
    
    func show(successMessage message: String) {
        AlertManager.shared.show(message: message, type: .image(.init(systemName: "checkmark.square.fill")))
    }
    func show(errorMessage message: String) {
        let errorImage: UIImage? = .init(systemName: "xmark.app.fill")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        AlertManager.shared.show(message: message, type: .image(errorImage))
    }
    
    func showRequiredLoginAlert() {
        self.presentCancelableAlert(
            title: "Login_alert_title",
            message: "Login_alert_message",
            actionTitle: "Login_alert_action_title") { [weak self] in
                let vc = UIViewController()
                vc.view.backgroundColor = .blue
                self?.present(vc, animated: true)
            }
    }
    
    func presentCancelableAlert(title: String, message: String, actionTitle: String, handler: @escaping (() -> Void)) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let titleAttributes = [NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.label]
        let titleString = NSAttributedString(string: title, attributes: titleAttributes)
        let messageAttributes = [NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel]
        let messageString = NSAttributedString(string: message, attributes: messageAttributes)
        
        alert.setValue(titleString, forKey: "attributedTitle")
        alert.setValue(messageString, forKey: "attributedMessage")
        
        let deleteAction = UIAlertAction(title: actionTitle, style: .destructive) { _ in
            handler()
        }
        let cancelAction = UIAlertAction(title: "alert_cancel_title", style: .cancel)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        alert.view.tintColor = .blue
        self.present(alert, animated: true)
    }
    
}




enum ViewState {
    case loading
    case error(error: Error)
}








































