//
//  RSMenuItemDispatcher.swift
//  Resource Studio
//
//  Created by 龚宇 on 22/05/14.
//

import Foundation
import AppKit

func RSDispatchMenuItem(_ menuItem: NSMenuItem) {
    switch menuItem.tag / 1000000 {
    case 1:
        
        break
    case 6:
        RSDispatchExHentaiMenuItem(menuItem)
        break
    case 7:
        RSDispatchGelbooruMenuItem(menuItem)
        break
    case 8:
        RSDispatchPixivMenuItem(menuItem)
        break
    case 9:
        RSDispatchRule34MenuItem(menuItem)
        break
    case 11:
        RSDispatchTorrentMenuItem(menuItem)
        break
    case 12:
        RSDispatchSiteMenuItem(menuItem)
        break
    case 13:
        RSDispatchDownloadMenuItem(menuItem)
        break
    default:
        break
    }
}
