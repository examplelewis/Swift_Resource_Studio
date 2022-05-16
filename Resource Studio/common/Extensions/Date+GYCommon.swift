//
//  Date+GYCommon.swift
//  GYSwiftLib
//
//  Created by 龚宇 on 22/04/23.
//

import Foundation

extension Date {
    
    static func current() -> Date {
        return Date(timeIntervalSinceNow: 0)
    }
    
    func string(format: String = GYTimeFormatyMdHms, locale: String = "zh_CN") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: locale)
        
        return formatter.string(from: self)
    }
}
