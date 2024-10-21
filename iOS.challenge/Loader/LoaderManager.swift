//
//  LoaderManager.swift
//  App
//
//  Created by MGAbouarab on 18/10/2024.
//

import UIKit

class LoaderManager {
    
    //MARK: - Properties -
    private var count: Int = 0 {
        didSet {
            if count == 0 {
                self.removeLoaderView()
            } else if count == 1 {
                self.addLoaderViewToWindow()
            }
        }
    }
    lazy private var loaderView = LoaderView()
    static let shared = LoaderManager()
    
    //MARK: - Initializer -
    private init() {
        self.loaderView.alpha = 0
        self.loaderView.backgroundColor = .black.withAlphaComponent(0)
    }
    
    //MARK: - Design -
    private func addLoaderViewToWindow() {
        guard let window = SceneDelegate.current?.window else {return}
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            guard self.count > 0 else {return}
            window.addSubview(self.loaderView)
            window.bringSubviewToFront(self.loaderView)
            self.loaderView.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
            self.loaderView.frame = window.frame
            UIView.animate(withDuration: 0.4) {
                self.loaderView.alpha = 1
                self.loaderView.backgroundColor = .black.withAlphaComponent(0.6)
            }
        }
    }
    private func removeLoaderView() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                self.loaderView.alpha = 0
                self.loaderView.backgroundColor = .black.withAlphaComponent(0)
            } completion: { _ in
                self.loaderView.removeFromSuperview()
            }
        }
    }
    
    //MARK: - Client -
    func show() {
        self.count += 1
    }
    func hide() {
        guard count > 0 else {return}
        self.count -= 1
    }
    
}
