//
//  WindowController.swift
//  Resource Studio
//
//  Created by 龚宇 on 22/05/14.
//

import Cocoa

class WindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
    
        RSUIManager.shared.windowController = self
    }

}
