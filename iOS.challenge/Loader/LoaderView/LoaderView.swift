//
//  LoaderView.swift
//  App
//
//  Created by MGAbouarab on 18/10/2024.
//

import UIKit

final class LoaderView: UIView {
    
    @IBOutlet weak private var loaderView: LottieView!
    
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
        let nib = UINib(nibName: "LoaderView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
        
    }
    
    //MARK: - Design -
    private func setupInitialDesign() {
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
    }
    
    //MARK: - Deinit -
    deinit {
        print("\(self.className) is deinit, No memory leak found")
    }
    
}
