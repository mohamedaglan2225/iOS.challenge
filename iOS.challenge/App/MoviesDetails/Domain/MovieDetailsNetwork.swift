//
//  MovieDetailsNetwork.swift
//  iOS.challenge
//
//  Created by Mohamed Aglan on 18/10/2024.
//

import Foundation

struct MovieDetailsNetwork {
    private init() {}
}

extension MovieDetailsNetwork {
    
    static func movieDetailsApi(movieId: Int) -> Endpoint<MovieDetailsModel> {
        return .init(method: .get, path: "3/movie/\(movieId)", headerType: .authorized(token: UserDefaults.accessToken ?? ""))
    }
}
