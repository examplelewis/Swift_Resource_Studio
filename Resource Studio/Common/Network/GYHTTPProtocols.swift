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
}

protocol GYHTTPResponseProtocol {
    func rspCode() -> String
    func rspDesc() -> String
}

typealias GYHTTPReqPackProtocol = GYHTTPPackageProtocol & GYHTTPRequestProtocol
typealias GYHTTPRspPackProtocol = GYHTTPPackageProtocol & GYHTTPResponseProtocol
