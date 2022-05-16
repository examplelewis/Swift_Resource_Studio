//
//  GYFoundation.swift
//  GYSwiftLib
//
//  Created by 龚宇 on 22/04/23.
//

import Foundation

// MARK: Time
func GYHumanReadableTime(fromInterval interval: TimeInterval) -> String {
    let minutes = Int(Int(interval) / 60)
    let seconds = Int(floor(interval - Double(minutes * 60)))
    let milliseconds = Int(floor(interval * 1000)) % 1000
    
    return String(format: "%02ld:%02ld:%03ld", minutes, seconds, milliseconds)
}

// MARK: Read
func GYReadTextFile(atPath filePath: String) -> String? {
    var content: String?
    do {
        content = try String(contentsOfFile: filePath, encoding: .utf8)
    } catch {
        GYLogManager.shared.addErrorLog(format: "文件路径: %@\n读取文件时出现错误: %@", filePath, error.localizedDescription)
    }
    
    return content
}

// MARK: Export
func GYExport(toPath path: String, string: String?, continueWhenExist: Bool, showSuccessLog: Bool) {
    guard string != nil else {
        return
    }
    
    var string = string!
    if GYFileManager.itemExists(atPath: path) {
        // 如果需要接着写的话，那么先添加分隔符
        if (continueWhenExist) {
            string = String(format: "\n\n----------%@ 添加内容----------\n\n%@", Date.current().string(format: GYTimeFormatyMdHms), string)
        } else {
            GYFileManager.removeItem(atPath: path)
        }
    }
    
    GYFileManager.createFile(atPath: path)
    
    guard let data = string.data(using: .utf8) else {
        return
    }
    
    let fileHandle = FileHandle(forWritingAtPath: path)
    fileHandle?.seekToEndOfFile()
    fileHandle?.write(data)
    
    do {
        try fileHandle?.close()
        if showSuccessLog {
            GYLogManager.shared.addDefaultLog(format: "结果文件导出成功，请查看：%@", path)
        }
    } catch {
        GYLogManager.shared.addErrorLog(format: "导出结果文件出错：%@", error.localizedDescription)
    }
}
func GYExport(toPlistPath path: String, data: Data, continueWhenExist: Bool, showSuccessLog: Bool) {
    if (try? data.write(to: GYFileManager.itemURL(fromPath: path))) != nil {
        if showSuccessLog {
            GYLogManager.shared.addDefaultLog(format: "结果文件导出成功，请查看：%@", path)
        }
    }
}
