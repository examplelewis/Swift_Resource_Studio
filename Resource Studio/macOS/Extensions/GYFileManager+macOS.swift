//
//  GYFileManager+macOS.swift
//  Resource Studio
//
//  Created by 龚宇 on 22/06/17.
//

import Foundation
import AppKit

extension GYFileManager {
    // MARK: Open
    class func openItem(atPath path: String) {
        NSWorkspace.shared.open(itemURL(fromPath: path))
    }
    class func openItem(atURL url: URL) {
        NSWorkspace.shared.open(url)
    }
    
    // MARK: Trash
    class func trashItems(atPaths paths: [String]) {
        trashItems(atURLs: itemURLs(fromPaths: paths))
    }
    class func trashItems(atURLs urls: [URL]) {
        NSWorkspace.shared.recycle(urls) { newURLs, error in
            if error == nil {
                GYLogManager.shared.addDefaultLog(format: "文件移动到废纸篓成功")
            } else {
                GYLogManager.shared.addErrorLog(format: "文件移动到废纸篓发生错误: %@", error!.localizedDescription)
            }
        }
    }
}
