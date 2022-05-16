//
//  GYMacros.swift
//  Resource Studio
//
//  Created by 龚宇 on 22/05/12.
//

import Foundation

// MARK: Base
func GYPrint(_ format: String, file: String = #file, function: String = #function, line: Int = #line, _ arguments: CVarArg...) {
    let message = String(format: format, arguments: arguments)
    let filename = (file as NSString).lastPathComponent
    let time = Date.current().string()
    let string = String(format: "%@ [%@: #%ld]\n%@\n", time, filename, line, message)
    
    print(string)
}
func GYSynchronized(_ lock: Any, closure: () -> Void) {
    objc_sync_enter(lock)
    closure()
    objc_sync_exit(lock)
}

// MARK: Foundation
// 将 Data 转换为 字符串
func GYStringFrom(data: Data?) -> String? {
    if data == nil {
        return nil
    } else {
        return String(bytes: data!, encoding: .utf8)
    }
}

// MARK: -> JSON String
// 将 任意对象 转换为 JSON String
func GYJSONStringFrom(object: Any?) -> String? {
    if object == nil {
        return nil
    }
    if !JSONSerialization.isValidJSONObject(object!) {
        return nil
    }
    
    do {
        let data = try JSONSerialization.data(withJSONObject: object!, options: .prettyPrinted)
        return GYStringFrom(data: data)
    } catch {
        GYPrint("JSONSerialization.data error: %@", error.localizedDescription)
    }
    
    return nil
}

// MARK: JSON Data ->
// 将 JSON Data 转换为 任意对象
func GYJSONObjectFrom(data: Data?) -> Any? {
    if data == nil {
        return nil
    }
    if !JSONSerialization.isValidJSONObject(data!) {
        return nil
    }
    
    do {
        return try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
    } catch {
        GYPrint("JSONSerialization 解析失败\nReason: %@", error.localizedDescription)
    }
    
    return nil
}
// 将 JSON Data 转换为 指定类型的对象
// let dictionary: [String: Any]? = GYJSONObjectFrom(data: data) // T 会转换为 [String: Any]
// let dictionary: [String: Any] = GYJSONObjectFrom(data: data) // 编译报错，因为GYJSONObjectFrom(data:) 返回的是可选值，T 没法带入
func GYObjectFrom<T>(data: Data?) -> T? {
    return GYJSONObjectFrom(data: data) as? T
}
// 将 JSON Data 转换为 字典
func GYDictionaryFrom(data: Data?) -> [String: Any]? {
    let dictionary: [String: Any]? = GYObjectFrom(data: data)
    return dictionary
}

