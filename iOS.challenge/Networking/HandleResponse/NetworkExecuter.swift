//
//  NetworkExecuter.swift
//  App
//
//  Created by Mohamed Aglan on 18/10/2024.
//

import Foundation

protocol NetworkExecuter {
    func execute(_ request: any Requestable, progress progressHandler: ((_ progress: Int)-> Void)?) async throws -> Data
}


