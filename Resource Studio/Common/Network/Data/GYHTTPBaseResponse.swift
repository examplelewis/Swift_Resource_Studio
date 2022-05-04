//
//  GYHTTPBaseResponse.swift
//  GYSwiftLib
//
//  Created by 龚宇 on 22/04/23.
//

import Foundation

class GYHTTPBaseResponse: GYHTTPBaseModel, GYHTTPResponseProtocol {
    required init() {}
    
    var code: String?
    var desc: String?
    
    var headers: [String: Any]?
    var success: Bool { code != nil && code! == "00000000" }
    
    // MARK: GYHTTPPackageProtocol
    func rspCode() -> String { code ?? "" }
    func rspDesc() -> String { desc ?? "" }
}
