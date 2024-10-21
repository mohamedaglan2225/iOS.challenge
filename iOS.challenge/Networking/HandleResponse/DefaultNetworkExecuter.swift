//
//  DefaultNetworkExecuter.swift
//  App
//
//  Created by Mohamed Aglan on 18/10/2024.
//

import Foundation
import Alamofire

struct DefaultNetworkExecuter: NetworkExecuter {
    
    func execute(_ request: any Requestable, progress progressHandler: ((_ progress: Int)-> Void)? = nil) async throws -> Data {
        
        guard let uploads = request.uploads, !uploads.isEmpty else {
            return try await self.send(request)
        }
        return try await self.upload(request, progress: progressHandler)
    }
    
    private func send(_ request: any Requestable) async throws -> Data {
        let result = await AF.request(request).serializingData().result
        return try self.handle(result)
    }
    private func upload(_ request: any Requestable, progress progressHandler: ((_ progress: Int)-> Void)?) async throws -> Data {
        var urlRequest = try request.asURLRequest()
        urlRequest.httpBody = nil
        let result = await AF.upload(multipartFormData: { multipartFormData in
            if let parameters = request.body?.compactMapValues({$0}) {
                for (key, value) in parameters {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
            }
            for item in request.uploads ?? [] {
                multipartFormData.append(item.data, withName: item.key, fileName: item.filenameWithExtension, mimeType: item.mimeType.rawValue)
            }
        }, with: urlRequest).uploadProgress(queue: .main) { progress in
            let value = Int(progress.fractionCompleted*100)
            progressHandler?(value)
            print("the Progress is \(value) %")
        }.serializingData().result
        return try self.handle(result)
    }
    private func handle(_ result: Result<Data,AFError>) throws -> Data {
        switch result {
        case .success(let data):
            return data
        case .failure(let error):
            throw error
        }
    }
}

