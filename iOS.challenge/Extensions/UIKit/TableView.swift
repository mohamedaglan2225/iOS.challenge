//
//  TableView+Ex.swift
//  iOS.challenge
//
//  Created by Mohamed Aglan on 18/10/2024.
//

import UIKit

extension UITableView {
    func register<T: UITableViewCell>(cellType: T.Type, bundle: Bundle? = nil) {
        let className = cellType.className
        let nib = UINib(nibName: className, bundle: bundle)
        register(nib, forCellReuseIdentifier: className)
    }
    func register<T: UITableViewCell>(cellTypes: [T.Type], bundle: Bundle? = nil) {
        cellTypes.forEach { register(cellType: $0, bundle: bundle) }
    }
    func dequeueReusableCell<T: UITableViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: type.className, for: indexPath) as! T
    }
}

extension UITableView {
    func sizeHeaderToFit() {
        guard let headerView = tableHeaderView else { return }
        
        let newHeight = headerView.systemLayoutSizeFitting(CGSize(width: frame.width, height: .greatestFiniteMagnitude), withHorizontalFittingPriority: .required, verticalFittingPriority: .defaultLow)
        var frame = headerView.frame
        
        // avoids infinite loop!
        if newHeight.height != frame.height {
            frame.size.height = newHeight.height
            headerView.frame = frame
            tableHeaderView = headerView
        }
    }
}
