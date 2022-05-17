//
//  GYTimeMacro.swift
//  Resource Studio
//
//  Created by 龚宇 on 22/05/17.
//

import Foundation

// MARK: Time
func GYHumanReadableTime(fromInterval interval: TimeInterval) -> String {
    let minutes = Int(Int(interval) / 60)
    let seconds = Int(floor(interval - Double(minutes * 60)))
    let milliseconds = Int(floor(interval * 1000)) % 1000
    
    return String(format: "%02ld:%02ld:%03ld", minutes, seconds, milliseconds)
}
