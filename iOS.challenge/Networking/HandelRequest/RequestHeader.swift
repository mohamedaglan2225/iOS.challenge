//
//  RequestHeader.swift
//  App
//
//  Created by Mohamed Aglan on 18/10/2024.
//

import Foundation

enum RequestHeaderType {
    
    case authorized(token: String)
    case unauthorized
    
    var header: [String:String] {
        
        var commonHeaders = [
            "Accept": "application/json",
            "Content-Type": "application/json",
            "lang": "en"
        ]
        
        switch self {
        case .authorized(let token):
            commonHeaders["Authorization"] = "Bearer \(token)"
            return commonHeaders
        case .unauthorized:
            return commonHeaders
        }
        
    }
    
}
