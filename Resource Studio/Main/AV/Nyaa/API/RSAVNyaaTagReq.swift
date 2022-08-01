//
//  RSAVNyaaTagReq.swift
//  Resource Studio
//
//  Created by 龚宇 on 22/05/22.
//

import Cocoa

class RSAVNyaaTagReq: GYHTTPBaseRequest {
    var tag = ""
    var page = 1 // 页码从1开始
    
    // MARK: GYHTTPRequestProtocol
    override func url() -> String { String(format: "https://sukebei.nyaa.si/?f=0&c=0_0&q=%@&p=%ld", tag, page) }
}
