//
//  GYHTTPDataTask.swift
//  GYSwiftLib
//
//  Created by 龚宇 on 22/04/25.
//

import Foundation

protocol GYHTTPDataDaskDelegate: AnyObject {
    func dataTaskDidFinished(_ dataTask: GYHTTPDataTask)
}

typealias GYHTTPSuccessBlock = (GYHTTPRequestProtocol, GYHTTPResponseProtocol) -> Void
typealias GYHTTPFailureBlock = (GYHTTPRequestProtocol, Error) -> Void
typealias GYHTTPCancelBlock = (GYHTTPRequestProtocol) -> Void

class GYHTTPDataTask: Comparable {
    var invalid = false
    
    let request: GYHTTPRequestProtocol
    var response: GYHTTPResponseProtocol?
    
    var successBlock: GYHTTPSuccessBlock?
    var failureBlock: GYHTTPFailureBlock?
    var cancelBlock: GYHTTPCancelBlock?
    
    weak var delegate: GYHTTPDataDaskDelegate?
    
    // MARK: Initial
    init(request: GYHTTPRequestProtocol, success: GYHTTPSuccessBlock? = nil, failure: GYHTTPFailureBlock? = nil, cancel: GYHTTPCancelBlock? = nil) {
        self.request = request
        self.successBlock = success
        self.failureBlock = failure
        self.cancelBlock = cancel
    }
    
    // MARK: Operation
    func cancel() {
        invalid = true
    }
    
    // MARK: Comparable
    static func == (lhs: GYHTTPDataTask, rhs: GYHTTPDataTask) -> Bool {
        return lhs.request.url() == lhs.request.url()
    }
    static func < (lhs: GYHTTPDataTask, rhs: GYHTTPDataTask) -> Bool {
        return lhs.request.url() < lhs.request.url()
    }
}
