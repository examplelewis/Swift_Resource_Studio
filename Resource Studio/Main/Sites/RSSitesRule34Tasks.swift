//
//  RSSitesRule34Tasks.swift
//  Resource Studio
//
//  Created by 龚宇 on 22/06/02.
//

import Cocoa

class RSSitesRule34Tasks: GYHTTPBaseTasks {
    func fetch(tags: String, offset: Int) {
        let req = RSSitesRule34Req()
        req.tags = tags
        
        send(req) { request, response in
            let aRsp = response as! RSSitesRule34Rsp
        } failure: { request, error in
            let a = ""
        }
    }
}
