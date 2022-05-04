//
//  GYAlamofire.swift
//  GYSwiftLib
//
//  Created by 龚宇 on 22/04/23.
//

import Foundation
import Alamofire

class GYAlamofire {
    static let shared = GYAlamofire()
    
    let session: Session
    
    init() {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 15
        configuration.timeoutIntervalForResource = 15
        configuration.allowsCellularAccess = true
        configuration.waitsForConnectivity = true
        configuration.headers = HTTPHeaders([:])
        
        let interceptor = Interceptor(adapters: [GYHTTPRequestAdapter()], retriers: [], interceptors: [])
        session = Session(configuration: configuration, interceptor: interceptor, serverTrustManager: GYHTTPServerTrustManager(evaluators: [:]), eventMonitors: [GYHTTPEventMonitor()])
    }
    
    
}
