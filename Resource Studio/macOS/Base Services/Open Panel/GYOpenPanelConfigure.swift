//
//  GYOpenPanelConfigure.swift
//  Resource Studio
//
//  Created by 龚宇 on 22/05/14.
//

import Foundation
import AppKit

class GYOpenPanelConfigure {
    var windowType: GYOpenPanelWindowType = .mainWindow
    var behavior: GYOpenPanelBehavior = .none
    var message: String = ""
    var prompt: String = "确定"
    var allowedFileTypes: [String]?
    var window: NSWindow?
    
    static var keyWindowConfigure: GYOpenPanelConfigure {
        let configure = GYOpenPanelConfigure()
        configure.windowType = .keyWindow
        
        return configure
    }
    static func keyWindowConfigureWith(behaivor: GYOpenPanelBehavior, message: String) -> GYOpenPanelConfigure {
        let configure = GYOpenPanelConfigure.keyWindowConfigure
        configure.behavior = behaivor
        configure.message = message
        
        return configure
    }
    static var mainWindowConfigure: GYOpenPanelConfigure {
        let configure = GYOpenPanelConfigure()
        configure.windowType = .mainWindow
        
        return configure
    }
    static func mainWindowConfigureWith(behaivor: GYOpenPanelBehavior, message: String) -> GYOpenPanelConfigure {
        let configure = GYOpenPanelConfigure.mainWindowConfigure
        configure.behavior = behaivor
        configure.message = message
        
        return configure
    }
    static func customWindowConfigureWith(window: NSWindow, behaivor: GYOpenPanelBehavior, message: String) -> GYOpenPanelConfigure {
        let configure = GYOpenPanelConfigure()
        configure.windowType = .customWindow
        configure.window = window
        configure.behavior = behaivor
        configure.message = message
        
        return configure
    }
}
