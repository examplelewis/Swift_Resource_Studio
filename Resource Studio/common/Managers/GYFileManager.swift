//
//  GYFileManager.swift
//  GYSwiftLib
//
//  Created by 龚宇 on 22/04/23.
//

import Foundation

class GYFileManager {
    // MARK: Create
    @discardableResult
    static func createFolder(atPath folderPath: String) -> Bool {
        if FileManager.default.fileExists(atPath: folderPath) {
            return true
        } else {
            var success = true
            do {
                try FileManager.default.createDirectory(at: itemURL(fromPath: folderPath), withIntermediateDirectories: true, attributes: nil)
            } catch {
                success = false
                GYLogManager.shared.addErrorLog(format: "创建文件夹 %@ 时发生错误: \n%@", folderPath, error.localizedDescription)
            }
            
            return success
        }
    }
    @discardableResult
    static func createFile(atPath filePath: String) -> Bool {
        if FileManager.default.fileExists(atPath: filePath) {
            return true
        } else {
            return FileManager.default.createFile(atPath: filePath, contents: nil)
        }
    }
    
    // MARK: Trash
    static func trashItem(atPath itemPath: String) -> Bool {
       return trashItem(atURL: GYFileManager.itemURL(fromPath: itemPath))
    }
    static func trashItem(atURL itemURL: URL) -> Bool {
        var nsURL: NSURL?
        return trashItem(atURL: itemURL, resultItemURL: &nsURL)
    }
    static func trashItem(atURL itemURL: URL, resultItemURL: inout NSURL?) -> Bool {
        var desc: String?
        do {
            try FileManager.default.trashItem(at: itemURL, resultingItemURL: &resultItemURL)
        } catch {
            desc = error.localizedDescription
        }
        
        if desc == nil {
            GYLogManager.shared.addDefaultLog(format: "%@ 已经被移动到废纸篓", itemURL.lastPathComponent)
            return true
        } else {
            GYLogManager.shared.addErrorLog(format: "移动文件 %@ 到废纸篓时发生错误: %@", itemURL.lastPathComponent, desc!)
            return false
        }
    }
    static func trashItem(atURL itemURL: URL, resultingItemURL: inout NSURL?) throws {
        do {
            try FileManager.default.trashItem(at: itemURL, resultingItemURL: &resultingItemURL)
        } catch {
            throw error
        }
    }
    
    // MARK: Remove
    static func removeItem(atPath itemPath: String) {
        try? FileManager.default.removeItem(at: GYFileManager.itemURL(fromPath: itemPath))
    }
    static func removeItem(atURL itemURL: URL) {
        try? FileManager.default.removeItem(at: itemURL)
    }
    
    // MARK: Move
    static func moveItem(at atPath: String, to toPath: String) {
        moveItem(at: GYFileManager.itemURL(fromPath: atPath), to: GYFileManager.itemURL(fromPath: toPath))
    }
    static func moveItem(at atURL: URL, to toURL: URL) {
        do {
            try FileManager.default.moveItem(at: atURL, to: toURL)
        } catch {
            GYLogManager.shared.addErrorLog(format: "移动文件 %@ 时发生错误: %@", atURL.lastPathComponent, error.localizedDescription)
        }
    }
    
    // MARK: Copy
    static func copyItem(at atPath: String, to toPath: String) {
        copyItem(at: GYFileManager.itemURL(fromPath: atPath), to: GYFileManager.itemURL(fromPath: toPath))
    }
    static func copyItem(at atURL: URL, to toURL: URL) {
        do {
            try FileManager.default.copyItem(at: atURL, to: toURL)
        } catch {
            GYLogManager.shared.addErrorLog(format: "拷贝文件 %@ 时发生错误: %@", atURL.lastPathComponent, error.localizedDescription)
        }
    }
    
    // MARK: 路径
    // 文件路径，可指定 需要/不需要 的后缀名
    static func filePaths(inFolder folderPath: String, extensions: [String] = [], needExtensions: Bool = true) -> [String] {
        guard var itemPaths = try? FileManager.default.contentsOfDirectory(atPath: folderPath) else {
            return []
        }
        
        itemPaths = filteredReturned(itemPaths: itemPaths) // 先过滤文件名
        itemPaths = itemPaths.compactMap({ (folderPath as NSString).appendingPathComponent($0) }) // 变成完整路径
        itemPaths = itemPaths.filter({ !itemIsFolder(atPath: $0) }) // 过滤掉文件夹
        
        if extensions.isEmpty {
            return itemPaths
        } else {
            var extensions = extensions
            extensions = extensions.compactMap({ $0.lowercased() })
            
            var results = itemPaths
            if needExtensions {
                results = results.filter({ extensions.contains(($0 as NSString).pathExtension.lowercased()) })
            } else {
                results = results.filter({ !extensions.contains(($0 as NSString).pathExtension.lowercased()) })
            }
            
            return results
        }
    }
    // 文件夹路径
    static func folderPaths(inFolder folderPath: String) -> [String] {
        guard var itemPaths = try? FileManager.default.contentsOfDirectory(atPath: folderPath) else {
            return []
        }
        
        itemPaths = filteredReturned(itemPaths: itemPaths) // 先过滤文件名
        itemPaths = itemPaths.compactMap({ (folderPath as NSString).appendingPathComponent($0) }) // 变成完整路径
        itemPaths = itemPaths.filter({ itemIsFolder(atPath: $0) }) // 过滤掉非文件夹
        
        return itemPaths
    }
    // 项目(文件&文件夹)路径
    static func itemPaths(inFolder folderPath: String) -> [String] {
        guard var itemPaths = try? FileManager.default.contentsOfDirectory(atPath: folderPath) else {
            return []
        }
        
        itemPaths = filteredReturned(itemPaths: itemPaths) // 先过滤文件名
        itemPaths = itemPaths.compactMap({ (folderPath as NSString).appendingPathComponent($0) }) // 变成完整路径
        
        return itemPaths
    }
    // 隐藏项目(文件&文件夹)路径
    static func hiddenItemPaths(inFolder folderPath: String) -> [String] {
        guard var itemPaths = try? FileManager.default.contentsOfDirectory(atPath: folderPath) else {
            return []
        }
        
        itemPaths = filteredReturnedHidden(itemPaths: itemPaths) // 先过滤文件名
        itemPaths = itemPaths.compactMap({ (folderPath as NSString).appendingPathComponent($0) }) // 变成完整路径
        
        return itemPaths
    }
    
    // MARK: 递归路径
    // 递归文件路径，可指定 需要/不需要 的后缀名
    static func allFilePaths(inFolder folderPath: String, extensions: [String] = [], needExtensions: Bool = true) -> [String] {
        guard var itemPaths = try? FileManager.default.subpathsOfDirectory(atPath: folderPath) else {
            return []
        }
        
        itemPaths = filteredReturned(itemPaths: itemPaths) // 先过滤文件名
        itemPaths = itemPaths.compactMap({ (folderPath as NSString).appendingPathComponent($0) }) // 变成完整路径
        itemPaths = itemPaths.filter({ !itemIsFolder(atPath: $0) }) // 过滤掉文件夹
        
        if extensions.isEmpty {
            return itemPaths
        } else {
            var extensions = extensions
            extensions = extensions.compactMap({ $0.lowercased() })
            
            var results = itemPaths
            if needExtensions {
                results = results.filter({ extensions.contains(($0 as NSString).pathExtension.lowercased()) })
            } else {
                results = results.filter({ !extensions.contains(($0 as NSString).pathExtension.lowercased()) })
            }
            
            return results
        }
    }
    // 递归文件夹路径
    static func allFolderPaths(inFolder folderPath: String) -> [String] {
        guard var itemPaths = try? FileManager.default.subpathsOfDirectory(atPath: folderPath) else {
            return []
        }
        
        itemPaths = filteredReturned(itemPaths: itemPaths) // 先过滤文件名
        itemPaths = itemPaths.compactMap({ (folderPath as NSString).appendingPathComponent($0) }) // 变成完整路径
        itemPaths = itemPaths.filter({ itemIsFolder(atPath: $0) }) // 过滤掉非文件夹
        
        return itemPaths
    }
    // 递归项目(文件&文件夹)路径
    static func allItemPaths(inFolder folderPath: String) -> [String] {
        guard var itemPaths = try? FileManager.default.subpathsOfDirectory(atPath: folderPath) else {
            return []
        }
        
        itemPaths = filteredReturned(itemPaths: itemPaths) // 先过滤文件名
        itemPaths = itemPaths.compactMap({ (folderPath as NSString).appendingPathComponent($0) }) // 变成完整路径
        
        return itemPaths
    }
    // 递归隐藏项目(文件&文件夹)路径
    static func allHiddenItemPaths(inFolder folderPath: String) -> [String] {
        guard var itemPaths = try? FileManager.default.subpathsOfDirectory(atPath: folderPath) else {
            return []
        }
        
        itemPaths = filteredReturnedHidden(itemPaths: itemPaths) // 先过滤文件名
        itemPaths = itemPaths.compactMap({ (folderPath as NSString).appendingPathComponent($0) }) // 变成完整路径
        
        return itemPaths
    }
    
    // MARK: Attributes
    static func allAttributesOfItem(atPath itemPath: String) -> [FileAttributeKey: Any]? {
        return (try? FileManager.default.attributesOfItem(atPath: itemPath))
    }
    static func attribute(_ attribute: FileAttributeKey, ofItemAtPath itemPath: String) -> Any? {
        guard let attributes = allAttributesOfItem(atPath: itemPath) else {
            return nil
        }
        
        return attributes[attribute]
    }
    
    // MARK: Size
    static func fileSize(atPath filePath: String) -> UInt64 {
        guard let attributes = allAttributesOfItem(atPath: filePath) else {
            return 0
        }
        
        return (attributes as NSDictionary).fileSize()
    }
    static func folderSize(atPath folderPath: String) -> UInt64 {
        var folderSize: UInt64 = 0
        let filePaths = allFilePaths(inFolder: folderPath)
        for filePath in filePaths {
            folderSize += fileSize(atPath: filePath)
        }
        
        return folderSize
    }
    
    // MARK: Size Description
    static func fileSizeDescription(atPath filePath: String) -> String {
        return sizeDescription(from: fileSize(atPath: filePath))
    }
    static func folderSizeDescription(atPath folderPath: String) -> String {
        return sizeDescription(from: folderSize(atPath: folderPath))
    }
    static func sizeDescription(from size: UInt64) -> String {
        if size < 1024 {
            return String(format: "%lld B", size)
        } else if size < (1024 * 1024) {
            return String(format: "%.2f KB", Float(size) / 1024.0)
        } else if size < (1024 * 1024 * 1024) {
            return String(format: "%.2f MB", Float(size) / 1024.0 / 1024.0)
        } else {
            return String(format: "%.2f GB", Float(size) / 1024.0 / 1024.0 / 1024.0)
        }
    }
        
    // MARK: Check
    static func itemExists(atPath itemPath: String) -> Bool {
        return FileManager.default.fileExists(atPath: itemPath)
    }
    static func itemIsFolder(atPath itemPath: String) -> Bool {
        var folderFlag: ObjCBool = false
        FileManager.default.fileExists(atPath: itemPath, isDirectory: &folderFlag)
        
        return folderFlag.boolValue
    }
    static func isEmptyFolder(atPath folderPath: String) -> Bool {
        return itemPaths(inFolder: folderPath).count == 0
    }
    
    // MARK: Panel
    static func pathFromOpenPanelURL(_ panelURL: URL) -> String {
        var path = panelURL.absoluteString
        path = path.replacingOccurrences(of: "%20", with: " ")
        path = path.replacingOccurrences(of: "file://", with: "")
        
        return path.removingPercentEncoding ?? ""
    }
    
    // MARK: Tool
    static func itemURL(fromPath itemPath: String) -> URL {
        return URL(fileURLWithPath: itemPath)
    }
    static func itemPath(fromURL itemURL: URL) -> String {
        return itemURL.path
    }
    static func itemURLs(fromPaths itemPaths: [String]) -> [URL] {
        return itemPaths.compactMap { URL(fileURLWithPath: $0) }
    }
    static func itemPaths(fromURLs itemURLs: [URL]) -> [String] {
        return itemURLs.compactMap { $0.path }
    }
    static func itemShouldIgnore(byPath itemPath: String) -> Bool {
        if (itemPath as NSString).lastPathComponent.hasPrefix(".") {
            return true
        }
        if itemPath.hasSuffix("DS_Store") {
            return true
        }
        if itemPath.range(of: "RECYCLE.BIN") != nil {
            return true
        }
        
        return false
    }
    static func hiddenItemShouldIgnore(byPath itemPath: String) -> Bool {
        if !(itemPath as NSString).lastPathComponent.hasPrefix(".") {
            return true
        }
        if itemPath.hasSuffix("DS_Store") {
            return true
        }
        if itemPath.range(of: "RECYCLE.BIN") != nil {
            return true
        }
        
        return false
    }
    static func filteredReturned(itemPaths: [String]) -> [String] {
        return itemPaths.filter({ !itemShouldIgnore(byPath: $0) })
    }
    static func filteredReturnedHidden(itemPaths: [String]) -> [String] {
        return itemPaths.filter({ !hiddenItemShouldIgnore(byPath: $0) })
    }
    static func removedSeparatorPath(fromPath itemPath: String) -> String {
        var newItemPath = itemPath
        var components = (newItemPath as NSString).pathComponents
        for index in 0..<components.count {
            if components[index].contains("/") && index != 0 {
                components[index] = components[index].replacingOccurrences(of: "/", with: " ")
            }
        }
        
        newItemPath = components.joined(separator: "/")
        newItemPath = newItemPath.substring(from: 1)
        
        return newItemPath
    }
    static func nonConflictItemPath(from itemPath: String) -> String {
        let isFolder = GYFileManager.itemIsFolder(atPath: itemPath)
        var newItemPath = itemPath
        var index = 2
        
        while itemExists(atPath: newItemPath) {
            if isFolder {
                newItemPath = itemPath.appendingFormat(" %ld", index)
            } else {
                newItemPath = (itemPath as NSString).deletingPathExtension.appendingFormat(" %ld.%@", index, (itemPath as NSString).pathExtension)
            }
            
            index += 1
        }
        
        return newItemPath
    }
}
