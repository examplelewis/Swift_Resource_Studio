//
//  RSGigaTagReq.swift
//  Resource Studio
//
//  Created by 龚宇 on 22/05/13.
//

import Cocoa

class RSGigaTagReq: GYHTTPBaseRequest {
    var id = 0
    
    // MARK: GYHTTPRequestProtocol
    override func url() -> String { String(format: "https://www.giga-web.jp/search/index.php?count=1&year=&month=&day=&narrow=&salesform_id=&tag_id=%ld&actor_id=&series_id=&label_id=&sort=1&s_type=&keyword=", id) }
}
