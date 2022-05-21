//
//  RSJavLibraryActorReq.swift
//  Resource Studio
//
//  Created by 龚宇 on 22/05/21.
//

import Cocoa

class RSJavLibraryActorReq: GYHTTPBaseRequest {
    var keyWord = ""
    var page = 1 // 页码从1开始
    
    // MARK: GYHTTPRequestProtocol
    override func url() -> String { String(format: "https://www.javlibrary.com/cn/vl_star.php?&mode=2&s=%@&page=1", keyWord, page) }
}
