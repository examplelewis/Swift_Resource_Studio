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
    static func unpack(data: Data?) -> Self? {
        if data == nil {
            return nil
        } else {
            return self.deserialize(from: String(decoding: data!, as: UTF8.self))
        }
    }
    
    // MARK: HandyJSON
    func mapping(mapper: HelpingMapper) {}
}
