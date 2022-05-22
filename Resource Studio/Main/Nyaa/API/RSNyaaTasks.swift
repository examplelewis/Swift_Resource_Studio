//
//  RSNyaaTasks.swift
//  Resource Studio
//
//  Created by 龚宇 on 22/05/22.
//

import Cocoa
import hpple

class RSNyaaTasks: GYHTTPBaseTasks {
    func fetchTagBy(tag: String, page: Int, callback: ((_ success: Bool, _ parser: TFHpple?) -> Void)?) {
        let req = RSNyaaTagReq()
        req.tag = tag
        req.page = page
        
        send(req) { request, response in
            let aRsp = response as! RSNyaaTagRsp
            callback?(aRsp.success, aRsp.parser)
        } failure: { request, error in
            callback?(false, nil)
        }
    }
}
