//
//  GYFileDefinition.swift
//  GYSwiftLib
//
//  Created by 龚宇 on 22/05/18.
//

import Foundation

struct GYFileBehavior: OptionSet {
    let rawValue: Int
    
    static let none = GYFileBehavior([])
    
    static let showSuccessLog = GYFileBehavior(rawValue: 1 << 0)
    static let showNoneLog = GYFileBehavior(rawValue: 1 << 1)
    static let exportNoneLog = GYFileBehavior(rawValue: 1 << 2)
    static let continueWhenExists = GYFileBehavior(rawValue: 1 << 3)
}
