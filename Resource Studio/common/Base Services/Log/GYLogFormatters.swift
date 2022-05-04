//
//  GYLogFormatters.swift
//  GYSwiftLib
//
//  Created by 龚宇 on 22/04/23.
//

import Foundation
import CocoaLumberjack

class GYFileLogFormatter: NSObject, DDLogFormatter {
    func format(message logMessage: DDLogMessage) -> String? {
        return logMessage.message
    }
}

class GYOSLogFormatter: NSObject, DDLogFormatter {
    func format(message logMessage: DDLogMessage) -> String? {
        return logMessage.message.components(separatedBy: "\n").last
    }
}
