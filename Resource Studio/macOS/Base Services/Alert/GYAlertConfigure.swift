//
//  GYAlertConfigure.swift
//  Resource Studio
//
//  Created by jsyh on 2022/7/21.
//

import Foundation
import AppKit

struct GYAlertConfigure {
    var alertStyle: NSAlert.Style = .warning
    var message = ""
    var info = ""
    var runModal = false
    
    static func infomationalConfigure(withMessage message: String, info: String = "") -> GYAlertConfigure {
        return configure(withStyle: .informational, message: message, info: info)
    }
    static func warningConfigure(withMessage message: String, info: String = "") -> GYAlertConfigure {
        return configure(withStyle: .warning, message: message, info: info)
    }
    static func criticalConfigure(withMessage message: String, info: String = "") -> GYAlertConfigure {
        return configure(withStyle: .critical, message: message, info: info)
    }
    
    private static func configure(withStyle style: NSAlert.Style, message: String, info: String, runModal: Bool = false) -> GYAlertConfigure {
        var configure = GYAlertConfigure()
        configure.alertStyle = style
        configure.message = message
        configure.info = info
        configure.runModal = runModal
        
        return configure
    }
}
