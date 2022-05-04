//
//  GYHTTPEventMonitor.swift
//  GYSwiftLib
//
//  Created by 龚宇 on 22/04/23.
//

import Foundation
import Alamofire

class GYHTTPEventMonitor: EventMonitor {
    func request(_ request: Request, didCreateURLRequest urlRequest: URLRequest) {
        GYHTTPPrinter.printRequest(urlRequest)
    }
}
