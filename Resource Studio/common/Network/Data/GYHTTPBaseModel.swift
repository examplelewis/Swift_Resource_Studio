//
//  GYHTTPBaseModel.swift
//  GYSwiftLib
//
//  Created by 龚宇 on 22/04/23.
//

import Foundation
import HandyJSON

class GYHTTPBaseModel: HandyJSON, GYHTTPPackageProtocol {
    required init() {}
    
    // MARK: GYHTTPPackageProtocol
    func pack() -> [String : Any]? { toJSON() }
    static func unpack(data: Data?) -> Self? { self.deserialize(from: "") }
    
    // MARK: HandyJSON
    func mapping(mapper: HelpingMapper) {}
}
