//
//  GYHTTPBaseRequest.swift
//  GYSwiftLib
//
//  Created by 龚宇 on 22/04/23.
//

import Foundation
import Alamofire

class GYHTTPBaseRequest: GYHTTPBaseModel, GYHTTPRequestProtocol {
    // MARK: GYHTTPRequestProtocol
    func url() -> String { "" }
    func rspType() -> GYHTTPBaseResponse.Type {
        let reqName = String(describing: type(of: self))
        var rspName = ""
        
        if reqName.hasSuffix("Request") {
            rspName = reqName.substring(to: (reqName.count - 7))
            rspName.append("Response")
        }
        if reqName.hasSuffix("Req") {
            rspName = reqName.substring(to: (reqName.count - 3))
            rspName.append("Rsp")
        }
        
        var namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
        namespace = namespace.replacingOccurrences(of: " ", with: "_")
        let responseClass: AnyClass = NSClassFromString("\(namespace).\(rspName)")!
        
        return responseClass as! GYHTTPBaseResponse.Type
    }
    func method() -> HTTPMethod { .get }
    func headers() -> [String : String] { [:] }
    func needUniversalToast() -> Bool { true }
    
    // 是否是HTML格式，如果是直接转成String
    func isHtml() -> Bool { true }
}
