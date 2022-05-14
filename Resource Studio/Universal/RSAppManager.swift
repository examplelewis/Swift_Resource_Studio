//
//  RSAppManager.swift
//  Resource Studio
//
//  Created by 龚宇 on 22/05/13.
//

import Foundation
import AppKit

class RSAppManager {
    static let shared = RSAppManager()
    
    
    
    // MARK: Setup
    func setup() {
        GYBase.shared.mainFolderPath = "/Users/Mercury/SynologyDrive/同步文档/Resource Studio"
        
        GYLogManager.shared.update(defaultColor: NSColor.labelColor, successColor: NSColor.systemGreen, warningColor: NSColor.systemYellow, errorColor: NSColor.systemRed, font: NSFont(name: "PingFangSC-Regular", size: 12.0)!)
    }
}
