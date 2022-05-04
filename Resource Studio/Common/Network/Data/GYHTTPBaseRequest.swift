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
        
        let namespace = Bundle.main.infoDictionary!["CFBundleExcutable"] as! String
        let responseClass: AnyClass = NSClassFromString("\(namespace).\(rspName)")!
        
        return responseClass as! GYHTTPBaseResponse.Type
    }
    func method() -> HTTPMethod { .get }
    func headers() -> [String : String] { [:] }
    func needUniversalToast() -> Bool { true }
}
