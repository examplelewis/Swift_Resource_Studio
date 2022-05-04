//
//  String+GYSubscript.swift
//  GYSwiftLib
//
//  Created by 龚宇 on 22/04/23.
//

import Foundation

extension String {
    /// 使用下标截取字符串
    /// string[index] 例如："abcdefg"[3] // c
    subscript (i: Int) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: i)
        let endIndex = self.index(startIndex, offsetBy: 1)
        
        return String(self[startIndex..<endIndex])
    }
    /// 使用半开半闭区间截取字符串
    /// string[a..<b] 例如："abcdefg"[3..<4] // d
    subscript (r: CountableRange<Int>) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
        let endIndex = self.index(self.startIndex, offsetBy: r.upperBound)
        
        return String(self[startIndex..<endIndex])
    }
    /// 使用全闭区间截取字符串
    /// string[a...b] 例如："abcdefg"[3...4] // de
    subscript (r: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)

        return String(self[start...end])
    }
    /// 使用下标截取字符串
    /// string[index, length] 例如："abcdefg"[3, 2] // de
    subscript (index: Int, length: Int) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: index)
        let endIndex = self.index(startIndex, offsetBy: length)
        
        return String(self[startIndex..<endIndex])
    }
    
    // 从 0 到 index 截取
    func substring(to: Int) -> String {
        return self[0..<to]
    }
    // 从 index 到 end 截取
    func substring(from: Int) -> String{
        return self[from..<self.count]
    }
}
