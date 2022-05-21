//
//  GYHTTPPrinter.swift
//  GYSwiftLib
//
//  Created by 龚宇 on 22/04/23.
//

import Foundation
import Alamofire

let GYHTTPPrintUnknown = "Unknown"

class GYHTTPPrinter {
    // MARK: Request
    class func printRequest(_ request: URLRequest) {
        let method = request.httpMethod ?? GYHTTPPrintUnknown
        var urlString = GYHTTPPrintUnknown
        let header = GYJSONStringFrom(object: request.allHTTPHeaderFields) ?? GYHTTPPrintUnknown
        var body: [String: String] = [:]
        
        if let url = request.url, let components = URLComponents(url: url, resolvingAgainstBaseURL: true) {
            urlString = _urlStringFrom(components: components)
            
            // 查询参数放到 Body 里面
            if let queryItems = components.queryItems {
                for queryItem in queryItems {
                    body[queryItem.name] = queryItem.value ?? ""
                }
            }
        }
        
        
        // 如果本身有httpbody字段，那么把httpbody内容放到body后
        if request.httpBody != nil, let httpBody = GYDictionaryFrom(data: request.httpBody!), httpBody is [String: String] {
            // 合并两个字典。block 的意思是当有重复数据的时候该如何选择
            // 下方代码的意思是当键对应的值有冲突时，取旧值: old，即已有字典body里面的数据
            body.merge(httpBody as! [String: String]) { (old, _) in old }
        }
        
        let bodyString = body.isEmpty ? "{}" : (GYJSONStringFrom(object: body) ?? GYHTTPPrintUnknown)
        GYPrint("****** Https Req ******\n%@：%@\nHeader: %@\nBody: %@", method, urlString, header, bodyString)
    }
    
    // MARK: Alamofire
    class func printAFDataResponse(_ dataResponse: AFDataResponse<Data>) {
        // 出错的内容不打印，Request Retrier 会打印所有出错信息
        if dataResponse.error == nil {
            printResponse(dataResponse.response, request: dataResponse.request, data: dataResponse.value)
        }
    }
    
    // MARK: Response
    class func printResponse(_ response: HTTPURLResponse?, request: URLRequest?, data: Data?) {
        let string = GYStringFrom(data: data)
        printResponse(response, request: request, string: string, dataCount: data?.count)
    }
    class func printResponse(_ response: HTTPURLResponse?, request: URLRequest?, string: String?, dataCount: Int?) {
        let method = request?.httpMethod ?? GYHTTPPrintUnknown
        var urlString = GYHTTPPrintUnknown
        let header = GYJSONStringFrom(object: response?.allHeaderFields) ?? GYHTTPPrintUnknown
        let count = dataCount ?? string?.count ?? -1
        
        if let url = request?.url, let components = URLComponents(url: url, resolvingAgainstBaseURL: true) {
            urlString = _urlStringFrom(components: components)
        }
        
        GYPrint("****** Https Rsp[%ld] ******\n%@：%@\nHeader: %@\nResponse[%ld]: %@", response?.statusCode ?? -1, method, urlString, header, count, string ?? GYHTTPPrintUnknown)
    }
    
    // MARK: Error
    class func printError(_ error: Error, request: Request) {
        printError(error, request: request.request, response: request.response)
    }
    class func printError(_ error: Error, request: URLRequest?, response: HTTPURLResponse?) {
        if let rspCode = response?.statusCode {
            let method = request?.httpMethod ?? GYHTTPPrintUnknown
            let urlString = request?.url?.absoluteString ?? GYHTTPPrintUnknown
            
            GYPrint("****** Https Error[HTTP: %ld] ******\n%@：%@", rspCode, method, urlString)
            
            return
        }
        
        let urlError = error as? URLError
        let afUrlError = error.asAFError?.underlyingError as? URLError
        if urlError != nil || afUrlError != nil {
            let rspCode = urlError?.code.rawValue ?? afUrlError?.code.rawValue ?? -1
            let method = request?.httpMethod ?? GYHTTPPrintUnknown
            let urlString = request?.url?.absoluteString ?? GYHTTPPrintUnknown
            let reason = urlError?.localizedDescription ?? afUrlError?.localizedDescription ?? GYHTTPPrintUnknown
            
            GYPrint("****** Https Error[Code: %ld] ******\n%@：%@\nReason: %@", rspCode, method, urlString, reason)
        }
        
        GYPrint("****** Https Error[TODO]")
    }
    
    // MARK: Cancel
    class func printCancel(_ request: GYHTTPReqPackProtocol) {
        GYPrint("****** Https Cancel ******\n%@: %@", request.method().rawValue, request.url())
    }
    
    // MARK: Tool
    class func _urlStringFrom(components: URLComponents) -> String {
        // URL 去除查询参数
        if let scheme = components.scheme, let host = components.host {
            if let port = components.port {
                return String(format: "%@://%@:%ld%@", scheme, host, port, components.path)
            } else {
                return String(format: "%@://%@%@", scheme, host, components.path)
            }
        } else {
            return GYHTTPPrintUnknown
        }
    }
}
