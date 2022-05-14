//
//  GYOpenPanelManager.swift
//  Resource Studio
//
//  Created by 龚宇 on 22/05/14.
//

import Foundation
import AppKit

class GYOpenPanelManager {
    static func showOpenPanelWith(configure: GYOpenPanelConfigure, pathsHandler: @escaping ((_ itemPaths: [String]) -> Void), otherHandler: ((_ openPanel: NSOpenPanel, _ response: NSApplication.ModalResponse) -> Void)? = nil) {
        let openPanel = NSOpenPanel()
        openPanel.message = String(format: "请选择%@", configure.message)
        openPanel.prompt = configure.prompt
        openPanel.canChooseDirectories = configure.behavior.contains(.chooseFolder)
        openPanel.canChooseFiles = configure.behavior.contains(.chooseFile)
        openPanel.canCreateDirectories = configure.behavior.contains(.createFolder)
        openPanel.allowsMultipleSelection = configure.behavior.contains(.multiple)
        openPanel.showsHiddenFiles = configure.behavior.contains(.showHidden)
        if configure.allowedFileTypes != nil, !configure.allowedFileTypes!.isEmpty {
            openPanel.allowedFileTypes = configure.allowedFileTypes
        }
        
        var window = configure.window
        if configure.windowType == .keyWindow {
            window = NSApplication.shared.keyWindow
        } else if configure.windowType == .mainWindow {
            window = NSApplication.shared.mainWindow
        }
        
        guard window != nil else {
            return
        }
        
        openPanel.beginSheetModal(for: window!) { response in
            if response == .OK {
                let itemPaths = openPanel.urls.compactMap({ GYFileManager.pathFromOpenPanelURL($0) })
                pathsHandler(itemPaths)
            } else {
                otherHandler?(openPanel, response)
            }
        }
    }
}
