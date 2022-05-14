//
//  GYHTTPCookie.swift
//  Resource Studio
//
//  Created by 龚宇 on 22/05/14.
//

import Foundation
import HandyJSON

class GYHTTPCookie: HandyJSON {
    var domain: String?
    var expirationDate: TimeInterval?
    var hostOnly: Bool?
    var httpOnly: Bool?
    var name: String?
    var path: String?
    var sameSite: String?
    var secure: Bool?
    var session: Bool?
    var storeId: Int?
    var value: String?
    var id: Int?
    
    required init() {}
}
