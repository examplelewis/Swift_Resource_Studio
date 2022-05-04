//
//  GYHTTPServerTrustManager.swift
//  GYSwiftLib
//
//  Created by 龚宇 on 22/04/23.
//

import Foundation
import Alamofire

class GYHTTPServerTrustManager: ServerTrustManager {
    override init(allHostsMustBeEvaluated: Bool = true, evaluators: [String : ServerTrustEvaluating]) {
        super.init(allHostsMustBeEvaluated: allHostsMustBeEvaluated, evaluators: evaluators)
    }
    
    override func serverTrustEvaluator(forHost host: String) throws -> ServerTrustEvaluating? {
        DisabledTrustEvaluator()
    }
}
