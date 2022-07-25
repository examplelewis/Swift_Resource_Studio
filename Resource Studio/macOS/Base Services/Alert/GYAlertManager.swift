//
//  GYAlertManager.swift
//  Resource Studio
//
//  Created by jsyh on 2022/7/21.
//

import Foundation
import AppKit

class GYAlertManager {
    // MARK: Show Normal Alert
    class func showAlertOnMainWindow(withConfigure configure: GYAlertConfigure, handler: ((_ returnCode: NSApplication.ModalResponse) -> Void)? = nil) {
        if let mainWindow = NSApplication.shared.mainWindow {
            showAlertOn(window: mainWindow, configure: configure, handler: handler)
        }
    }
    class func showAlertOnKeyWindow(withConfigure configure: GYAlertConfigure, handler: ((_ returnCode: NSApplication.ModalResponse) -> Void)? = nil) {
        if let keyWindow = NSApplication.shared.keyWindow {
            showAlertOn(window: keyWindow, configure: configure, handler: handler)
        }
    }
    class func showAlertOn(window: NSWindow, configure: GYAlertConfigure, handler: ((_ returnCode: NSApplication.ModalResponse) -> Void)? = nil) {
        let alert = alert(withConfigure: configure)
        alert.addButton(withTitles: ["好"], keyEquivalents: [.returnKey])
        
        showAlert(alert: alert, onWindow: window, handler: handler)
    }
    class func showAlert(alert: GYAlert, onWindow window: NSWindow, handler: ((_ returnCode: NSApplication.ModalResponse) -> Void)? = nil) {
        if alert.isRunModal {
            alert.response = alert.runModal()
        } else {
            alert.beginSheetModal(for: window, completionHandler: handler)
        }
    }
    
    // MARK: Show Input Alert
    class func showInputAlertOnKeyWindow(withConfigure configure: GYAlertConfigure, firstHandler: ((_ inputString: String) -> Void)? = nil) {
        showInputAlertOnKeyWindow(withConfigure: configure, firstHandler: firstHandler, otherHandler: nil)
    }
    class func showInputAlertOnKeyWindow(withConfigure configure: GYAlertConfigure, firstHandler: ((_ inputString: String) -> Void)? = nil, otherHandler: ((_ returnCode: NSApplication.ModalResponse) -> Void)? = nil) {
        if let keyWindow = NSApplication.shared.keyWindow {
            showInputAlertOn(window: keyWindow, configure: configure, firstHandler: firstHandler, otherHandler: otherHandler)
        }
    }
    class func showInputAlertOn(window: NSWindow, configure: GYAlertConfigure, firstHandler: ((_ inputString: String) -> Void)? = nil, otherHandler: ((_ returnCode: NSApplication.ModalResponse) -> Void)? = nil) {
        let alert = inputAlert(withConfigure: configure)
        alert.addButton(withTitles: ["好"], keyEquivalents: [.returnKey])
        
        showInputAlert(alert: alert, onWindow: window, firstHandler: firstHandler, otherHandler: otherHandler)
    }
    class func showInputAlert(alert: GYAlert, onWindow window: NSWindow, firstHandler: ((_ inputString: String) -> Void)? = nil, otherHandler: ((_ returnCode: NSApplication.ModalResponse) -> Void)? = nil) {
        if alert.isRunModal {
            alert.response = alert.runModal()
        } else {
            alert.beginSheetModal(for: window) { (returnCode: NSApplication.ModalResponse) in
                if returnCode == .alertFirstButtonReturn {
                    firstHandler?(alert.textView!.string)
                } else {
                    otherHandler?(returnCode)
                }
            }
        }
        
        alert.window.makeFirstResponder(alert.textView)
    }
    
    // MARK: Alerts
    class func alert(withConfigure configure: GYAlertConfigure) -> GYAlert {
        let alert = GYAlert()
        alert.alertStyle = configure.alertStyle
        alert.messageText = configure.message
        alert.isRunModal = configure.runModal
        if !configure.info.isEmpty {
            alert.informativeText = configure.info
        }
        
        return alert
    }
    class func inputAlert(withConfigure configure: GYAlertConfigure) -> GYAlert {
        let alert = alert(withConfigure: configure)
        alert.addTextView()
        
        return alert
    }
}
