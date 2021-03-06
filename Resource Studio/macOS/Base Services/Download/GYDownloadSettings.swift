//
//  GYDownloadSettings.swift
//  Resource Studio
//
//  Created by 龚宇 on 22/05/14.
//

import Foundation
import AppKit

class GYDownloadSettings {
    static let shared = GYDownloadSettings()
    
    let settings: [GYDownloadSetting] = [.defaultInput, .defaultPanel, .concurrent1Input, .concurrent1Panel, .concurrent5Input, .concurrent5Panel, .concurrent10Input, .concurrent10Panel, .resourceSitesInput, .resourceSitesPanel, .videoInput, .videoPanel]
    
    // MARK: Settings
    func settingFrom(menuItemTag: Int) -> GYDownloadSetting? {
        let filtered = settings.filter({ $0.menuItemTag == menuItemTag })
        if filtered.count > 0 {
            return filtered.first
        } else {
            return nil
        }
    }
    func updateMenuItems(withBaseTag baseTag: Int, callback: ((_ menu: NSMenu) -> Void)? = nil) {
        let menu = NSMenu()
        menu.title = "下载"
        
        var menuItemTag = 0
        for (index, setting) in settings.enumerated() {
            // 添加分隔符
            if index % 2 == 0 {
                if menuItemTag / 100 != (setting.menuItemTag) / 100 {
                    menuItemTag = setting.menuItemTag
                    menu.addItem(.separator())
                }
            }
            
            let menuItem = NSMenuItem()
            menuItem.title = String(format: "%@ [%@]", setting.menuItemTitle, setting.source == .input ? "输入" : "选择文件")
            menuItem.tag = setting.menuItemTag + baseTag
            if setting.source == .panel {
                menuItem.isAlternate = true
                menuItem.keyEquivalentModifierMask = .option
            }
            menuItem.target = self
            menuItem.action = #selector(downloadMenuItemDidPress(_:))
            
            menu.addItem(menuItem)
        }
        
        callback?(menu)
    }
    @objc private func downloadMenuItemDidPress(_ sender: NSMenuItem) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: GYDwonloadMenuItemDispatchNotificationKey), object: sender)
    }
}
