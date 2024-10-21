//
//  Requestable.swift
//  App
//
//  Created by Mohamed Aglan on 18/10/2024.
//

import Foundation

protocol Requestable: RequestConvertible {
    
    associatedtype Response: Decodable
    
    var server: String {get}
    var method: RequestMethod {get}
    var path: String {get}
    var headerType: RequestHeaderType {get}
    var queries: APIParameters? {get}
    var body: APIParameters? {get}
    var uploads: [UploadData]? {get}
    var decoder: ResponseDecoder {get}
    
}
extension Requestable {
    func asURLRequest() throws -> URLRequest {
        
        //MARK: - URL -
        var urlRequest = URLRequest(url: try server.asURL().appendingPathComponent(path))
        
        //MARK: - HTTTP Method -
        urlRequest.httpMethod = method.rawValue
        
        //MARK: - Common Headers -
        for header in headerType.header {
            urlRequest.setValue(header.value, forHTTPHeaderField: header.key)
        }
        
        //MARK: - Parameters -
        if let queries = queries?.compactMapValues({$0}) {
            urlRequest = try URLRequestEncoding.default.encode(urlRequest, with: queries)
        }
        if let body = body?.compactMapValues({$0}) {
            urlRequest = try JSONRequestEncoding.default.encode(urlRequest, with: body)
        }
        
        //MARK: - All Request data
        #if DEBUG
        print(
              """
              
              ====================================
              🚀🚀FULL REQUEST COMPONENETS:::
              
              URL:: \(urlRequest.url?.absoluteString ?? "No URL Found")
              ---------------------------------
              Method:: \(urlRequest.httpMethod ?? "No httpMethod")
              ---------------------------------
              Header::
              \((urlRequest.allHTTPHeaderFields ?? [:]).json())
              ---------------------------------
              Queries::
              \((queries?.compactMapValues({$0}) ?? [:]).json())
              ---------------------------------
              Body::
              \((body?.compactMapValues({$0}) ?? [:]).json())
              
              ====================================
              
              """
        )
        #endif
        
        return urlRequest
    }
}
