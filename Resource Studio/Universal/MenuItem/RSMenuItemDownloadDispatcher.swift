//
//  RSMenuItemDownloadDispatcher.swift
//  Resource Studio
//
//  Created by 龚宇 on 22/05/14.
//

import Foundation
import AppKit

func GYDispatchDownloadMenuItem(_ menuItem: NSMenuItem) {
    GYLogManager.shared.reset()
    
    let setting = GYDownloadSettings.shared.settingFrom(menuItemTag: menuItem.tag)
    if setting == nil {
        GYLogManager.shared.addErrorLog(format: "未找到匹配的配置文件，下载流程结束")
        return
    }
    
    switch setting!.source {
    case .input:
        
        break
    case .panel:
        
        break
    }
}

fileprivate func _dispatchBy(setting: GYDownloadSetting, URLString: String, txtFilePath: String?) {
    if URLString.count == 0 {
        GYLogManager.shared.addWarningLog(format: "未读取到可用的下载链接, 下载流程结束")
        return
    }
    
    let URLs = URLString.components(separatedBy: "\n")
    let manager = GYDownloadManager(setting: setting, URLs: URLs, txtFilePath: txtFilePath)
    manager.start()
}
