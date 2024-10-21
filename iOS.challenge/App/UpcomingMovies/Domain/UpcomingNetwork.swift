//
//  UpcomingNetwork.swift
//  iOS.challenge
//
//  Created by Mohamed Aglan on 18/10/2024.
//

import Foundation

struct UpcomingNetwork {
    private init() {}
}

extension UpcomingNetwork {
    
    static func upcomingMoviesApi(page: Int) -> Endpoint<UpcomingMoviesModel> {
        return .init(method: .get, path: "3/movie/upcoming", queries: ["page": page] , headerType: .authorized(token: UserDefaults.accessToken ?? ""))
    }
    
    
}
