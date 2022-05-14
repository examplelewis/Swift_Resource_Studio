//
//  GYLogManager.swift
//  GYSwiftLib
//
//  Created by 龚宇 on 22/04/23.
//

import Foundation
import CocoaLumberjack

class GYLogManager {
    static let shared = GYLogManager()
    
    private var defaultColor: Any = "" // 先设置默认为空字符串，调用 update 方法改
    private var successColor: Any = "" // 先设置默认为空字符串，调用 update 方法改
    private var warningColor: Any = "" // 先设置默认为空字符串，调用 update 方法改
    private var errorColor: Any = "" // 先设置默认为空字符串，调用 update 方法改
    private var font: Any = "" // 先设置默认为空字符串，调用 update 方法改
    
//    private var logs: [String] = [] // 日志
    private var latestLog: NSAttributedString?
    private var current: Date?
    private var lock = NSLock()
    
    // MARK: Initial
    init() {
        // Setup Logger
        let managerDefault = DDLogFileManagerDefault(logsDirectory: GYBase.shared.logFolderPath)
        let fileLogger = DDFileLogger(logFileManager: managerDefault)
        fileLogger.logFormatter = GYFileLogFormatter()
        fileLogger.rollingFrequency = 60 * 60 * 24 * 7
        fileLogger.logFileManager.maximumNumberOfLogFiles = 3
        fileLogger.maximumFileSize = 10 * 1024 * 1024
        DDLog.add(fileLogger)
        
        let osLogger = DDOSLogger.sharedInstance
        osLogger.logFormatter = GYOSLogFormatter()
        DDLog.add(osLogger)
    }
    
    // MARK: UI
    func update(defaultColor: Any, successColor: Any, warningColor: Any, errorColor: Any, font: Any) {
        self.defaultColor = defaultColor
        self.successColor = successColor
        self.warningColor = warningColor
        self.errorColor = errorColor
        self.font = font
    }
    
    // MARK: Clean / Reset
    func clean() {
        lock.lock()
        latestLog = nil
//        logs.removeAll()
        lock.unlock()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: GYLogCleanNotificationKey), object: nil)
    }
    func reset() {
        lock.lock()
        current = Date(timeIntervalSinceNow: 0)
        latestLog = nil
//        logs.removeAll()
        lock.unlock()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: GYLogCleanNotificationKey), object: nil)
    }
    
    // MARK: 换行
    func addNewLineLog() {
        _add(log: "", behavior: [.levelDefault, .onBothTimeAppend])
    }
    
    // MARK: 在 页面和文件 上 显示时间 并且 添加新的日志
    func addDefaultLog(format: String, _ arguments: CVarArg...) {
        let log = String(format: format, arguments: arguments)
        _add(log: log, behavior: [.levelDefault, .onBothTimeAppend])
    }
    func addSuccessLog(format: String, _ arguments: CVarArg...) {
        let log = String(format: format, arguments: arguments)
        _add(log: log, behavior: [.levelSuccess, .onBothTimeAppend])
    }
    func addWarningLog(format: String, _ arguments: CVarArg...) {
        let log = String(format: format, arguments: arguments)
        _add(log: log, behavior: [.levelWarning, .onBothTimeAppend])
    }
    func addErrorLog(format: String, _ arguments: CVarArg...) {
        let log = String(format: format, arguments: arguments)
        _add(log: log, behavior: [.levelError, .onBothTimeAppend])
    }
    
    // MARK: 在 页面和文件 上 显示时间 并且 新的日志覆盖之前的日志
    func addReplaceDefaultLog(format: String, _ arguments: CVarArg...) {
        let log = String(format: format, arguments: arguments)
        _add(log: log, behavior: [.levelDefault, .onBothTime])
    }
    func addReplaceSuccessLog(format: String, _ arguments: CVarArg...) {
        let log = String(format: format, arguments: arguments)
        _add(log: log, behavior: [.levelSuccess, .onBothTime])
    }
    func addReplaceWarningLog(format: String, _ arguments: CVarArg...) {
        let log = String(format: format, arguments: arguments)
        _add(log: log, behavior: [.levelWarning, .onBothTime])
    }
    func addReplaceErrorLog(format: String, _ arguments: CVarArg...) {
        let log = String(format: format, arguments: arguments)
        _add(log: log, behavior: [.levelError, .onBothTime])
    }
    
    // MARK: 自定义
    func addDefaultLog(behavior: GYLogBehavior, format: String, _ arguments: CVarArg...) {
        let log = String(format: format, arguments: arguments)
        _add(log: log, behavior: [.levelDefault, behavior])
    }
    func addSuccessLog(behavior: GYLogBehavior, format: String, _ arguments: CVarArg...) {
        let log = String(format: format, arguments: arguments)
        _add(log: log, behavior: [.levelSuccess, behavior])
    }
    func addWarningLog(behavior: GYLogBehavior, format: String, _ arguments: CVarArg...) {
        let log = String(format: format, arguments: arguments)
        _add(log: log, behavior: [.levelWarning, behavior])
    }
    func addErrorLog(behavior: GYLogBehavior, format: String, _ arguments: CVarArg...) {
        let log = String(format: format, arguments: arguments)
        _add(log: log, behavior: [.levelError, behavior])
    }
    
    // MARK: 内部实现
    private func _add(log: String, behavior: GYLogBehavior) {
        if behavior.contains(.none) {
            return
        }
        
        // 日志内容
        var logString = ""
        if behavior.contains(.showTime) {
            if current != nil {
                let interval = Date.current().timeIntervalSince(current!)
                logString = logString.appendingFormat("%@ | %@\t\t", Date.current().stringWith(format: GYTimeFormatyMdHmsS), GYHumanReadableTime(fromInterval: interval))
                
                let logsSize = (logString as NSString).size(withAttributes: [.font: font])
                if logsSize.width < 250 {
                    logString.append("\t")
                }
            } else {
                logString = logString.appendingFormat("%@\t\t", Date.current().stringWith(format: GYTimeFormatyMdHmsS))
            }
        }
        
        logString.append(log)
        
        // 本地日志
        if behavior.contains(.onDDLog) {
            var localLogString = logString
            
            let firstTabsRange = (localLogString as NSString).range(of: "\t\t\t")
            // 正常情况下第一次出现三个\t的location应该是35。如果超过35，那就表明第一次出现三个\t是在具体的日志内容中，不应替换
            if (firstTabsRange.location == 35) {
                localLogString = (localLogString as NSString).replacingCharacters(in: firstTabsRange, with: "\t\t")
            }
            
            if behavior.contains(.levelDefault) {
                saveDefault(log: localLogString)
            } else if behavior.contains(.levelSuccess) {
                saveSuccess(log: localLogString)
            } else if behavior.contains(.levelWarning) {
                saveWarning(log: localLogString)
            } else if behavior.contains(.levelError) {
                saveError(log: localLogString)
            }
        }
        
        if behavior.contains(.onView) {
            // 添加日志的样式
            var textColor = defaultColor
            if behavior.contains(.levelSuccess) {
                textColor = successColor
            } else if behavior.contains(.levelWarning) {
                textColor = warningColor
            } else if behavior.contains(.levelError) {
                textColor = errorColor
            }
            let attributedLog = NSAttributedString(string: logString, attributes: [.foregroundColor: textColor, .font: font])
            
            // 生成日志
            let realLog = GYLog(normalLog: attributedLog, latestLog: latestLog?.string)
            realLog.shouldAppend = (behavior.contains(.appendLog) || latestLog == nil)
            
            // 发送通知
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: GYLogShowNotificationKey), object: realLog)
            // 将日志滚动到最前面
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: GYLogScrollLatestNotificationKey), object: nil)
            
            lock.lock()
            latestLog = attributedLog
//            if !(behavior.contains(.appendLog)) && latestLog != nil {
//                logs.removeLast()
//            }
//            logs.addObject(attributedLog)
            lock.unlock()
        }
    }
    
    // MARK: 保存
    func saveDefault(log: String) {
        DDLogDebug(log)
    }
    func saveSuccess(log: String) {
        DDLogInfo(log)
    }
    func saveWarning(log: String) {
        DDLogWarn(log)
    }
    func saveError(log: String) {
        DDLogError(log)
    }
}
