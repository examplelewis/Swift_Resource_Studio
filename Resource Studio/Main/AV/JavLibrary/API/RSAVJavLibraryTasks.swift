//
//  RSAVJavLibraryTasks.swift
//  Resource Studio
//
//  Created by 龚宇 on 22/05/21.
//

import Cocoa
import hpple

class RSAVJavLibraryTasks: GYHTTPBaseTasks {
    func fetchActorBy(keyWord: String, page: Int, callback: ((_ success: Bool, _ parser: TFHpple?) -> Void)?) {
        let req = RSAVJavLibraryActorReq()
        req.keyWord = keyWord
        req.page = page
        
        send(req) { request, response in
            let aRsp = response as! RSAVJavLibraryActorRsp
            callback?(aRsp.success, aRsp.parser)
        } failure: { request, error in
            callback?(false, nil)
        }
    }
}
