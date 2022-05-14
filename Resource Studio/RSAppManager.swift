//
//  RSAppManager.swift
//  Resource Studio
//
//  Created by 龚宇 on 22/05/13.
//

import Foundation

class RSAppManager {
    static let shared = RSAppManager()
    
    func setup() {
        GYBase.shared.rootFolderPath = "/Users/Mercury/SynologyDrive/同步文档/Resource Studio"
    }
}
