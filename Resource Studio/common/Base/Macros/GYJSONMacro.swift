//
//  GYJSONMacro.swift
//  Resource Studio
//
//  Created by 龚宇 on 22/05/17.
//

import Foundation

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

// MARK: JSON String ->
// 将 JSON String 转换为 数组
func SPTArrayFrom(jsonString: String?) -> [Any]? {
    let data = jsonString?.data(using: .utf8)
    let array: [Any]? = GYObjectFrom(data: data)
    return array
}

// 将 JSON String 转换为 字典
func SPTDictionaryFrom(jsonString: String?) -> [String: Any]? {
    let data = jsonString?.data(using: .utf8)
    let dictionary: [String: Any]? = GYObjectFrom(data: data)
    return dictionary
}
