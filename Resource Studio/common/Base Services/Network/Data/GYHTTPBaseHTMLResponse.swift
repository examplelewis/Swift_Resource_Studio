//
//  GYHTTPBaseHTMLResponse.swift
//  Resource Studio
//
//  Created by 龚宇 on 22/05/13.
//

import Cocoa
import hpple

class GYHTTPBaseHTMLResponse: GYHTTPBaseResponse {
    var parser: TFHpple?
    
    override var success: Bool { parser != nil }
}
