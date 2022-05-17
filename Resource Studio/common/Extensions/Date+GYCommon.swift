//
//  Date+GYCommon.swift
//  GYSwiftLib
//
//  Created by 龚宇 on 22/04/23.
//

import Foundation

extension Date {
    var components: DateComponents { Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self) }
    
    // MARK: Date
    static func current() -> Date {
        return Date(timeIntervalSinceNow: 0)
    }
    static func today() -> Date {
        let components = Date.current().components
        return date(year: components.year, month: components.month, day: components.day)!
    }
    static func date(year: Int?, month: Int?, day: Int?, hour: Int? = 0, minute: Int? = 0, second: Int? = 0) -> Date? {
        var components = Date.current().components
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        components.second = second
        
        return Calendar.current.date(from: components)
    }
    
    // MARK: Format
    func string(format: String = GYTimeFormatyMdHms, locale: String = "zh_CN") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: locale)
        
        return formatter.string(from: self)
    }
    
    // MARK: Compare
    func isSameDay(_ date: Date = Date.current()) -> Bool {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
    
        let cSelf = calendar.dateComponents([.year, .month, .day], from: self)
        let cDate = calendar.dateComponents([.year, .month, .day], from: date)
    
        return (cSelf.year == cDate.year) && (cSelf.month == cDate.month) && (cSelf.day == cDate.day)
    }
}
