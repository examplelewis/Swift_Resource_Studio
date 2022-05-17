//
//  GYStringMacro.swift
//  Resource Studio
//
//  Created by 龚宇 on 22/05/17.
//

import Foundation

// MARK: Read
func GYReadTextFile(atPath filePath: String) -> String? {
    do {
        return try String(contentsOfFile: filePath, encoding: .utf8)
    } catch {
        GYLogManager.shared.addErrorLog(format: "文件路径: %@\n读取文件时出现错误: %@", filePath, error.localizedDescription)
    }
    
    return nil
}

// MARK: Data -> String
// 将 Data 转换为 字符串
func GYStringFrom(data: Data?) -> String? {
    if data == nil {
        return nil
    } else {
        return String(bytes: data!, encoding: .utf8)
    }
}
