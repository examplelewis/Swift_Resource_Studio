//
//  GYBase.swift
//  Resource Studio
//
//  Created by 龚宇 on 22/05/14.
//

import Foundation

class GYBase {
    static let shared = GYBase()
    
    // MARK: System Folder Path
    let downloadFolderPath: String
    
    // MARK: App Folder Path
    var mainFolderPath = ""
    var cookieFolderPath: String { (mainFolderPath as NSString).appendingPathComponent("Cookies") }
    var logFolderPath: String { (mainFolderPath as NSString).appendingPathComponent("Logs") }
    var dbFolderPath: String { (mainFolderPath as NSString).appendingPathComponent("Databases") }
    var prefFolderPath: String { (mainFolderPath as NSString).appendingPathComponent("Preferences") }
    
    // MARK: Initial
    init() {
        let url = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!
        downloadFolderPath = GYFileManager.pathFromOpenPanelURL(url)
    }
    
    // MARK: Paths
    func pathOfItemInDownloadFolder(_ component: String) -> String {
        return (downloadFolderPath as NSString).appendingPathComponent(component)
    }
    func pathOfItemInMainFolder(_ component: String) -> String {
        return (mainFolderPath as NSString).appendingPathComponent(component)
    }
    func sqliteFilePath(_ fileName: String) -> String {
        var file = fileName
        if !fileName.hasSuffix(".sqlite") {
            file = fileName.appending(".sqlite")
        }
        
        return (dbFolderPath as NSString).appendingPathComponent(file)
    }
    func preferenceFilePath(_ fileName: String) -> String {
        var file = fileName
        if !fileName.hasSuffix(".plist") {
            file = fileName.appending(".plist")
        }
        
        return (prefFolderPath as NSString).appendingPathComponent(file)
    }
}
