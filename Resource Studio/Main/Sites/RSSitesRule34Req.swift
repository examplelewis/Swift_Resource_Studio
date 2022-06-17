//
//  RSSitesRule34Req.swift
//  Resource Studio
//
//  Created by 龚宇 on 22/06/02.
//

import Cocoa

class RSSitesRule34Req: GYHTTPBaseRequest {
    var tags = ""
    var pid = 0 // 偏移量从0开始
    
    // MARK: GYHTTPRequestProtocol
    override func url() -> String { "https://r34-json-api.herokuapp.com/posts" }
    override func isHtml() -> Bool { false }
}
