//
//  String+GYCommon.swift
//  GYSwiftLib
//
//  Created by 龚宇 on 22/04/23.
//

import Foundation

extension String {
    // MARK: MD5
    var md5Middle: String {
        // MD5都是32位的
        if self.count == 32 {
            return String(self[8..<24])
        } else {
            return self
        }
    }
    var md5Middle8: String {
        // MD5都是32位的
        if self.count == 32 {
            return String(self[12..<20])
        } else {
            return self
        }
    }
    
    // MARK: Emoji
    var isSingleEmoji: Bool { count == 1 && containsEmoji }
    var containsEmoji: Bool { contains { $0.isEmoji } }
    var containsOnlyEmoji: Bool { !isEmpty && !contains { !$0.isEmoji } }
    
    var emojis: [Character] { filter { $0.isEmoji } }
    var nonEmojis: [Character] { filter { !$0.isEmoji } }
    
    var emojiString: String { emojis.map { String($0) }.reduce("", +) }
    var nonEmojisString: String { nonEmojis.map { String($0) }.reduce("", +) }
    
    var emojiScalars: [UnicodeScalar] { filter { $0.isEmoji }.flatMap { $0.unicodeScalars } }
    
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
        
        GYFoundation.export(toPath: path, string: self, continueWhenExist: behavior.contains(.continueWhenExists), showSuccessLog: behavior.contains(.showSuccessLog))
    }
}
