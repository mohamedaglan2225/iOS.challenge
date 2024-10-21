//
//  TopAlert.swift
//  App
//
//  Created by Mohamed Aglan on 18/10/2024.
//

import UIKit

class TopAlert: UIView {
    
    enum AlertType {
        case image(UIImage?)
        case lottie(fileName: String)
    }
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var label: UILabel!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var lottieView: LottieView!
    
    //MARK: - Initializer -
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.xibSetUp()
        self.setupInitialDesign()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.xibSetUp()
        self.setupInitialDesign()
    }
    
    private func xibSetUp() {
        let view = loadViewFromNib()
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    private func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "TopAlert", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
        
    }
    
    //MARK: - Design -
    private func setupInitialDesign() {
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        self.tintColor = .blue
    }
    
    //MARK: - Data -
    func set(message: String, type: AlertType) {
        self.label.text = message
        switch type {
        case .image(let image):
            self.imageView.image = image
            self.imageView.isHidden = false
            self.lottieView.isHidden = true
        case .lottie(let fileName):
            self.lottieView.animationName = fileName
            self.imageView.isHidden = true
            self.lottieView.isHidden = false
        }
    }
    
    //MARK: - Deinit -
    deinit {
        print("\(self.className) is deinit, No memory leak found")
    }
    
}
