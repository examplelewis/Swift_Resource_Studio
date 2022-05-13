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
    
    func sendTask(_ task: GYHTTPDataTask) {
        let request = task.request
        let dataRequest = GYHTTPDataRequest(url: request.url(), method: request.method(), headers: request.headers(), parameters: request.pack())
        
        session.request(dataRequest).responseData { (dataResponse: AFDataResponse<Data>) in
            GYHTTPPrinter.printAFDataResponse(dataResponse)
            
            if dataResponse.error != nil {
                task.rspError = dataResponse.error
            } else if let urlRequest = dataResponse.request, let _ = urlRequest.url, let urlResponse = dataResponse.response {
                task.rspHeader = urlResponse.allHeaderFields as? [String: Any]
                
                let baseResponse: GYHTTPBaseResponse? = request.rspType().unpack(data: dataResponse.value)
                baseResponse?.headers = task.rspHeader
                
                // 如果baseResponse为nil，那么说明服务器反回的JSON字符串解析错误
                if baseResponse == nil {
                    task.rspError = URLError(.cannotDecodeContentData)
                } else {
                    task.response = baseResponse
                }
            } else {
                task.rspError = URLError(.cannotParseResponse)
            }
            
            if !task.invalid {
                task.delegate?.dataTaskDidFinished(task)
            }
        }
    }
}
