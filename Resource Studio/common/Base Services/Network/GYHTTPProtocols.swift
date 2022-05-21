//
//  GYHTTPProtocols.swift
//  GYSwiftLib
//
//  Created by 龚宇 on 22/04/23.
//

import Foundation
import Alamofire

protocol GYHTTPPackageProtocol {
    func pack() -> [String: Any]?
    static func unpack(data: Data?) -> Self?
}

protocol GYHTTPRequestProtocol {
    func url() -> String
    func rspType() -> GYHTTPBaseResponse.Type
    func method() -> HTTPMethod
    func headers() -> [String: String]
    func needUniversalToast() -> Bool
    
    // 是否是 HTML 格式，是的话，直接转成 String 即可
    func isHtml() -> Bool
}

protocol GYHTTPResponseProtocol {
    func rspCode() -> String
    func rspDesc() -> String
}

typealias GYHTTPReqPackProtocol = GYHTTPPackageProtocol & GYHTTPRequestProtocol
typealias GYHTTPRspPackProtocol = GYHTTPPackageProtocol & GYHTTPResponseProtocol
