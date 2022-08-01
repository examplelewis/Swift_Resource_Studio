//
//  GYBase+RSExtensions.swift
//  Resource Studio
//
//  Created by jsyh on 2022/8/1.
//

import Foundation

extension GYBase {
    // MARK: APP File Path 
    var mainPrefFilePath: String { GYBase.shared.pathOfPreference("RSPreference") }
    var pixivUtilDBPath: String { String(format: "%@%@", NSHomeDirectory(), RSPixivUtilDBFilePath) }
}
