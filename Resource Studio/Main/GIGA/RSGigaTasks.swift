//
//  RSGigaTasks.swift
//  Resource Studio
//
//  Created by 龚宇 on 22/05/13.
//

import Cocoa
import hpple

class RSGigaTasks: GYHTTPBaseTasks {
    func fetchTagBy(id: Int) {
        let req = RSGigaTagReq()
        req.id = id
        
//        GYHTTPCookieManager.setupGigaCookie()
        
        send(req) { request, response in
            let aRsp = response as! RSGigaTagRsp
            
            guard let parser = aRsp.parser else {
                return
            }
            
            var divArray = parser.search(withXPathQuery: "//div") as? [TFHppleElement]
            divArray = divArray?.filter({
                if let classObj = $0.attributes["class"], let classString = classObj as? String {
//                    print(classString)
                    return classString == "col s12 m12 l10 center"
                } else {
                    return false
                }
            })
            
//            print(divArray)
            
            guard divArray != nil, divArray!.count > 0 else {
                return
            }
            
            
            
        } failure: { request, error in
            
        }
    }
}

//fileprivate let gigaHTTPCookieProperties: [HTTPCookiePropertyKey: Any] = [.name: "old_check", .path: "/", .value: "yes", .secure: false, .domain: ".www.giga-web.jp"]
