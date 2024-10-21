//
//  ResponseError.swift
//  App
//
//  Created by Mohamed Aglan on 18/10/2024.
//

import Foundation

enum ResponseError: Error {
    case canNotConnectToServer
    case serverError
    case unableToDecodeResponse
    case server(message: String)
}

extension ResponseError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .canNotConnectToServer:
            return "Can not send request, please check your connection"
        case .serverError:
            return "There is an error in our servers and we work on it, please try again later"
        case .unableToDecodeResponse:
            return "unexpected error happened and we will work on it, please try again later"
        case .server(let message):
            return message
        }
    }
}

