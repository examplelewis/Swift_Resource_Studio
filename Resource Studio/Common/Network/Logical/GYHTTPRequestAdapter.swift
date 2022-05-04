//
//  GYHTTPRequestAdapter.swift
//  GYSwiftLib
//
//  Created by 龚宇 on 22/04/23.
//

import Foundation
import Alamofire

class GYHTTPRequestAdapter: RequestAdapter {
    init() {}
    
    // MARK: RequestAdapter
    func adapt(_ urlRequest: URLRequest, using state: RequestAdapterState, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        let request = _adapt(urlRequest)
        completion(.success(request))
    }
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        let request = _adapt(urlRequest)
        completion(.success(request))
    }
    
    // MARK: Internal
    func _adapt(_ urlRequest: URLRequest) -> URLRequest {
        var urlRequest = urlRequest
        urlRequest.headers.add(name: "Accept", value: "application/json")
        urlRequest.headers.update(name: "Content-Type", value: "application/json")
        
        return urlRequest
    }
}
