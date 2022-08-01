//
//  RSAVGigaTasks.swift
//  Resource Studio
//
//  Created by 龚宇 on 22/05/13.
//

import Cocoa
import hpple

class RSAVGigaTasks: GYHTTPBaseTasks {
    func fetchTagBy(tagID: String, page: Int, callback: ((_ success: Bool, _ parser: TFHpple?) -> Void)?) {
        let req = RSAVGigaTagReq()
        req.tagID = Int(tagID)!
        req.page = page
        
        send(req) { request, response in
            let aRsp = response as! RSAVGigaTagRsp
            callback?(aRsp.success, aRsp.parser)
        } failure: { request, error in
            callback?(false, nil)
        }
    }
}
