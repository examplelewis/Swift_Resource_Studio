//
//  GYLog.swift
//  GYSwiftLib
//
//  Created by 龚宇 on 22/04/23.
//

import Foundation

class GYLog {
    var type: GYLogType = .normal
    var attributedLog = NSAttributedString()
    var latestLog: String?
    var shouldAppend = false
    
    init(type: GYLogType, log: NSAttributedString, latestLog: String?) {
        self.type = type
        self.attributedLog = log
        self.latestLog = latestLog
    }
    
    convenience init(normalLog log: NSAttributedString, latestLog: String?) {
        self.init(type: .normal, log: log, latestLog: latestLog)
    }
    
    convenience init(fileLog log: NSAttributedString, latestLog: String?) {
        self.init(type: .file, log: log, latestLog: latestLog)
    }
}
