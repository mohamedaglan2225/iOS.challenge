//
//  UIImageView.swift
//  App
//
//  Created by Mohamed Aglan on 18/10/2024.
//

import UIKit.UIImageView
import Kingfisher

extension UIImageView {
    func setWith(_ stringURL: String?) {
        self.kf.indicatorType = .activity
        let placeholder = UIImage(named: "EmptyImage")
        guard let stringURL, let url = URL(string: stringURL) else {
            self.image = UIImage(named: "EmptyImage")
            return
        }
        self.kf.setImage(
            with: url,
            placeholder: placeholder,
            options: [
                .onFailureImage(placeholder),
                .transition(.fade(0.4))
            ]
        )
    }
}
