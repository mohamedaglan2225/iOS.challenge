//
//  NetworkReachability.swift
//  iOS.challenge
//
//  Created by Mohamed Aglan on 18/10/2024.
//

import Alamofire

struct NetworkReachability {
    static let shared = NetworkReachability()
    
    private let reachabilityManager = NetworkReachabilityManager()
    
    func isConnectedToInternet() -> Bool {
        return reachabilityManager?.isReachable ?? false
    }
}
