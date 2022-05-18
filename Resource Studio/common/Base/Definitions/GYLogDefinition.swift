//
//  GYLogDefinition.swift
//  GYSwiftLib
//
//  Created by 龚宇 on 22/05/18.
//

import Foundation

struct GYLogBehavior: OptionSet {
    let rawValue: Int
    
    // None
    static let none = GYLogBehavior([])
    
    // Level
    static let levelDefault = GYLogBehavior(rawValue: 1 << 0)
    static let levelSuccess = GYLogBehavior(rawValue: 1 << 1)
    static let levelWarning = GYLogBehavior(rawValue: 1 << 2)
    static let levelError = GYLogBehavior(rawValue: 1 << 3)
    
    // On
    static let onView = GYLogBehavior(rawValue: 1 << 5)
    static let onDDLog = GYLogBehavior(rawValue: 1 << 6)
    static let onBoth: GYLogBehavior = [.onView, .onDDLog]
    
    // Other
    static let showTime = GYLogBehavior(rawValue: 1 << 9) // 日志显示时间
    static let appendLog = GYLogBehavior(rawValue: 1 << 10) // 新日志添加到旧日志后，不删除旧日志
    
    // Combine
    static let onViewTimeAppend: GYLogBehavior = [.onView, .showTime, .appendLog]
    static let onDDLogTimeAppend: GYLogBehavior = [.onDDLog, .showTime, .appendLog]
    static let onBothTimeAppend: GYLogBehavior = [.onBoth, .showTime, .appendLog]
    
    static let onViewAppend: GYLogBehavior = [.onView, .appendLog]
    static let onDDLogAppend: GYLogBehavior = [.onDDLog, .appendLog]
    static let onBothAppend: GYLogBehavior = [.onBoth, .appendLog]
    
    static let onViewTime: GYLogBehavior = [.onView, .showTime]
    static let onDDLogTime: GYLogBehavior = [.onDDLog, .showTime]
    static let onBothTime: GYLogBehavior = [.onBoth, .showTime]
}

enum GYLogType: Int {
    case normal
    case file
}
