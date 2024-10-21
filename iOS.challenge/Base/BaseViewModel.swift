//
//  BaseViewModel.swift
//  App
//
//  Created by Mohamed Aglan on 18/10/2024.
//
 
import Foundation

class BaseViewModel: NSObject, ObservableObject {
    
    @Published
    var error: Error?
    
    let responseHandler: ResponseHandler
    
    init(responseHandler: ResponseHandler = DefaultResponseHandler()) {
        self.responseHandler = responseHandler
    }
    
    func request<ResponseData: Decodable>(_ endPoint: Endpoint<BaseResponse<ResponseData>>, progress: ((_ progress: Int)-> Void)? = nil) async throws -> ResponseData? {
        let response = try await self.responseHandler.get(endPoint, progress: progress)
        
        switch response.key {
        case .success:
            return response.data
        case .fail:
            throw ResponseError.server(message: response.message)
        case .unauthenticated, .blocked:
//            let vc = await LoginView()
//            AppHelper.changeWindowRoot(vc: vc)
            return nil
        case .needActive:
            return response.data
        case .exception:
            throw ResponseError.serverError
        }
        
    }
    func requestFullResponse<ResponseData: Decodable>(_ endPoint: Endpoint<BaseResponse<ResponseData>>, progress: ((_ progress: Int)-> Void)? = nil) async throws -> BaseResponse<ResponseData> {
        return try await self.responseHandler.get(endPoint, progress: progress)
    }
   
    func requestGeneralResponse<ResponseData: Decodable>(_ endPoint: Endpoint<ResponseData>, progress: ((_ progress: Int)-> Void)? = nil) async throws -> ResponseData {
        return try await self.responseHandler.get(endPoint, progress: progress)
    }
    
    deinit {
        print("\(NSStringFromClass(self.classForCoder).components(separatedBy: ".").last ?? "BaseViewModel") is deinit, No memory leak found")
    }
    
}
