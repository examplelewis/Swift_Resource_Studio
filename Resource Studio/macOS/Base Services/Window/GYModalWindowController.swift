//
//  GYModalWindowController.swift
//  Resource Studio
//
//  Created by jsyh on 2022/7/21.
//

import Cocoa

class GYModalWindowController: NSWindowController, NSWindowDelegate {
    var modalResponse = NSApplication.ModalResponse(rawValue: 0)

    override func windowDidLoad() {
        super.windowDidLoad()
    
        window?.delegate = self
    }
    
    // MARK: NSWindowDelegate
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        NSApplication.shared.stopModal(withCode: modalResponse)
        
        return true
    }
}
