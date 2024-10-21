//
//  ClassNameProtocol.swift
//  App
//
//  Created by Mohamed Aglan on 18/10/2024.
//

import Foundation

protocol ClassNameProtocol {
    static var className: String { get }
    var className: String { get }
}
extension ClassNameProtocol {
    static var className: String {
        return String(describing: self)
    }

    var className: String {
        return type(of: self).className
    }
}
extension NSObject: ClassNameProtocol {}

