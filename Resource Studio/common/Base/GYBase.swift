//
//  GYBase.swift
//  Resource Studio
//
//  Created by 龚宇 on 22/05/14.
//

import Foundation

class GYBase {
    static let shared = GYBase()
    
    var rootFolderPath = ""
    var cookieFolderPath: String { (rootFolderPath as NSString).appendingPathComponent("Cookies") }
}
