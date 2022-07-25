//
//  GYWindowManager.swift
//  Resource Studio
//
//  Created by jsyh on 2022/7/21.
//

import Foundation
import AppKit

class GYWindowManager {
    static let shared = GYWindowManager()
    
    var windowControllers: [GYWindowController] = []
    var lock = NSLock()
    
    func showWindowController(windowController: GYWindowController) {
        windowControllers.append(windowController)
        windowController.showWindow(nil)
    }
    func closeWindowController(windowController: GYWindowController) {
        if let index = windowControllers.firstIndex(of: windowController) {
            windowControllers.remove(at: index)
        }
    }
}
