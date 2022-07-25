//
//  GYWindowController.swift
//  Resource Studio
//
//  Created by jsyh on 2022/7/21.
//

import Cocoa

class GYWindowController: NSWindowController, NSWindowDelegate {

    override func windowDidLoad() {
        super.windowDidLoad()
    
        window?.delegate = self
    }
    
    // MARK: NSWindowDelegate
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        GYWindowManager.shared.closeWindowController(windowController: self)
        
        return true
    }
}
