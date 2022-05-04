//
//  Array+GYCommon.swift
//  GYSwiftLib
//
//  Created by 龚宇 on 22/04/23.
//

import Foundation

extension Array {
    // MARK: Duplicates
    var nonDuplicates: Self {
        let orderedSet = NSOrderedSet(array: self)
        return orderedSet.array as! Self
    }
    
    // MARK: String
    var stringValue: String {
        if self is [String] {
            return (self as! [String]).joined(separator: "\n")
        } else {
            return ""
        }
    }
    var readableJSONString: String? {
        if readableJSONData == nil {
            return nil
        } else {
            return String(data: readableJSONData!, encoding: .utf8)
        }
    }
    var readableJSONData: Data? {
        if isEmpty {
            return nil
        } else {
            let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return data
        }
    }
    
    // MARK: Export
    func export(toPath path: String) {
        export(toPath: path, continueWhenExist: true)
    }
    func export(toPath path: String, continueWhenExist: Bool) {
        var behavior: GYFileBehavior = .none
        if continueWhenExist {
           behavior = behavior.union(.continueWhenExists)
        } else {
            behavior.remove(.continueWhenExists)
        }
        
        export(toPath: path, behavior: behavior)
    }
    func export(toPath path: String, behavior: GYFileBehavior) {
        if isEmpty {
            if behavior.contains(.showNoneLog) {
                GYLogManager.shared.addWarningLog(format: "输出到: %@ 的内容为空，已忽略", path)
            }
            if !behavior.contains(.exportNoneLog) {
                return
            }
        }
        
        GYFoundation.export(toPath: path, string: stringValue, continueWhenExist: behavior.contains(.continueWhenExists), showSuccessLog: behavior.contains(.showSuccessLog))
    }
    func export(toPlistPath path: String) {
        export(toPlistPath: path, behavior: .none)
    }
    func export(toPlistPath path: String, behavior: GYFileBehavior) {
        if isEmpty {
            if behavior.contains(.showNoneLog) {
                GYLogManager.shared.addWarningLog(format: "输出到: %@ 的内容为空，已忽略", path)
            }
            if !behavior.contains(.exportNoneLog) {
                return
            }
        }
        
        do {
            let data = try PropertyListSerialization.data(fromPropertyList: self, format: .binary, options: 0)
            GYFoundation.export(toPlistPath: path, data: data, continueWhenExist: behavior.contains(.continueWhenExists), showSuccessLog: behavior.contains(.showSuccessLog))
        } catch {
            GYLogManager.shared.addErrorLog(format: "导出结果文件出错：%@", error.localizedDescription)
        }
    }
}
