//
//  GYHTTPDataRequest.swift
//  Resource Studio
//
//  Created by 龚宇 on 22/05/09.
//

import Foundation
import Alamofire

class GYHTTPDataRequest: URLRequestConvertible {
    let url: URLConvertible
    let method: HTTPMethod
    let headers: [String: String]?
    let parameters: [String: Any]?
    let encoding: ParameterEncoding = URLEncoding.default
    
    init(url: URLConvertible, method: HTTPMethod = .get, headers: [String: String]? = nil, parameters: [String: Any]? = nil) {
        self.url = url
        self.method = method
        self.headers = headers
        self.parameters = parameters
    }
    
    // MARK: URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        var httpHeaders: HTTPHeaders?
        if headers != nil, headers!.count > 0 {
            httpHeaders = HTTPHeaders(headers!)
        }
        
        let urlRequest = try URLRequest(url: url, method: method, headers: httpHeaders)
        return try encoding.encode(urlRequest, with: parameters)
    }
}
