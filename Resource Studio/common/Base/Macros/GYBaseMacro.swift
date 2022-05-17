//
//  GYBaseMacro.swift
//  Resource Studio
//
//  Created by 龚宇 on 22/05/12.
//

import Foundation

// MARK: Print
func GYPrint(_ format: String, file: String = #file, function: String = #function, line: Int = #line, _ arguments: CVarArg...) {
    let message = String(format: format, arguments: arguments)
    let filename = (file as NSString).lastPathComponent
    let time = Date.current().string()
    let string = String(format: "%@ [%@: #%ld]\n%@\n", time, filename, line, message)
    
    print(string)
}

// MARK: Synchronize
func GYSynchronized(_ lock: Any, closure: () -> Void) {
    objc_sync_enter(lock)
    closure()
    objc_sync_exit(lock)
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
