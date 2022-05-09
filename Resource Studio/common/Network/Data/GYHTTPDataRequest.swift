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
    
    init(url: URLConvertible) {
        self.url = url
    }
    
    // MARK: URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        
    }
}
