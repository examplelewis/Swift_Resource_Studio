//
//  RSMenuItemDispatcher.swift
//  Resource Studio
//
//  Created by 龚宇 on 22/05/14.
//

import Foundation
import AppKit

func GYDispatchMenuItem(_ menuItem: NSMenuItem) {
    switch menuItem.tag / 1000000 {
    case 1:
        
        break
    case 4:
        GYDispatchDownloadMenuItem(menuItem)
        
        break
    case 5:
        
        break
    default:
        break
    }
}
