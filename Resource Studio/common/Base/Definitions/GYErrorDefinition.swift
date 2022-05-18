//
//  GYErrorDefinition.swift
//  GYSwiftLib
//
//  Created by 龚宇 on 22/05/18.
//

import Foundation

enum GYDownloadErrorType: Int {
    case undefined
    case connectionLost
}
enum GYErrorType: Equatable {
    case undefined
    case download(GYDownloadErrorType)
}