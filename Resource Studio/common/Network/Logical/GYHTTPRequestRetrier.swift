//
//  GYHTTPRequestRetrier.swift
//  Resource Studio
//
//  Created by 龚宇 on 22/05/12.
//

import Foundation
import Alamofire

class GYHTTPRequestRetrier: RequestRetrier {
    private let retryLimit = 3
    private let retryHTTPCodes: Set<Int> = [403]
    private let retryErrorCodes: Set<Int> = []
    
    // MARK: Initial
    init() {}
    
    // MARK: RequestRetrier
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        GYHTTPPrinter.printError()
    }
    private func _shouldRetry() -> Bool {
        
        
        return true
    }
}
