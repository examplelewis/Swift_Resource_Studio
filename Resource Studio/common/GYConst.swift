//
//  GYCommonConst.swift
//  GYSwiftLib
//
//  Created by 龚宇 on 22/04/23.
//

import Foundation

// MARK: File Behavior
struct GYFileBehavior: OptionSet {
    let rawValue: Int
    
    static let none = GYFileBehavior([])
    
    static let showSuccessLog = GYFileBehavior(rawValue: 1 << 0)
    static let showNoneLog = GYFileBehavior(rawValue: 1 << 1)
    static let exportNoneLog = GYFileBehavior(rawValue: 1 << 2)
    static let continueWhenExists = GYFileBehavior(rawValue: 1 << 3)
}

// MARK: Error Type
enum GYDownloadErrorType: Int {
    case undefined
    case connectionLost
}
enum GYErrorType: Equatable {
    case undefined
    case download(GYDownloadErrorType)
}

// MARK: Log
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

// MARK: Time Format
let GYTimeFormatCompactyMd = "yyyyMMdd";
let GYTimeFormatyMdHms = "yyyy-MM-dd HH:mm:ss";
let GYTimeFormatyMdHmsS = "yyyy-MM-dd HH:mm:ss.SSS";
let GYTimeFormatEMdHmsZy = "EEE MMM dd HH:mm:ss Z yyyy";
let GYTimeFormatyMdHmsCompact = "yyyyMMddHHmmss";

// MARK: Content
// Warning
let GYWarningNoneContentFoundInInputTextView = "没有获得任何输入内容，请检查输入框";
let GYWarningWrongContentFoundInInputTextView = "输入框的内容有误，请检查";

// MARK: Notification Keys
// 日志相关
// 以下通知都需要在主线程上跑：dispatch_main_async_safe((^{   }));
let GYLogCleanNotificationKey = "com.gongyu.GYSwiftLib.notification.keys.log.clean";
let GYLogScrollLatestNotificationKey = "com.gongyu.GYSwiftLib.notification.keys.log.scroll.latest";
let GYLogShowNotificationKey = "com.gongyu.GYSwiftLib.notification.keys.log.show";
