//
//  GYDownloadSetting.swift
//  Resource Studio
//
//  Created by 龚宇 on 22/05/14.
//

import Foundation

enum GYDownloadSource: Int {
    case input // 输入
    case panel // OpenPanel
}

class GYDownloadSetting {
    let menuItemTitle: String
    var menuItemTag: Int
    
    let folderPath: String // 下载的根文件夹地址
    let source: GYDownloadSource // 下载地址的来源
    let showFinishAlert: Bool // 下载完成后是否显示警告
    let maxConcurrentCount: Int // 并发数
    let maxRedownloadTimes: Int // 最大的重新下载次数
    let timeoutInterval: TimeInterval // 超时时间
    
    var headers: [String: String]? // 下载的请求头
    var renameInfo: [String: String]? // 文件重命名的记录
    
    // MARK: Initial
    init(menuItemTitle: String, menuItemTag: Int = 0, folderPath: String = GYBase.shared.downloadFolderPath, headers: [String: String]? = nil, showFinishAlert: Bool = true, maxConcurrentCount: Int = 15, maxRedownloadTimes: Int = 3, timeoutInterval: TimeInterval = 30.0, source: GYDownloadSource = .input, renameInfo: [String: String]? = nil) {
        self.menuItemTitle = menuItemTitle
        self.menuItemTag = menuItemTag
        self.folderPath = folderPath
        self.headers = headers
        self.showFinishAlert = showFinishAlert
        self.maxConcurrentCount = maxConcurrentCount
        self.maxRedownloadTimes = maxRedownloadTimes
        self.timeoutInterval = timeoutInterval
        self.source = source
        self.renameInfo = renameInfo
    }
    
    // MARK: Instance
    static let defaultInput = GYDownloadSetting(menuItemTitle: "默认设置", menuItemTag: GYDownloadMenuItemStartTag + 1, maxConcurrentCount: 15, source: .input)
    static let defaultPanel = GYDownloadSetting(menuItemTitle: "默认设置", menuItemTag: GYDownloadMenuItemStartTag + 2, maxConcurrentCount: 15, source: .panel)

    static let concurrent1Input = GYDownloadSetting(menuItemTitle: "同时下载1个", menuItemTag: GYDownloadMenuItemStartTag + 100 + 1, maxConcurrentCount: 1, source: .input)
    static let concurrent1Panel = GYDownloadSetting(menuItemTitle: "同时下载1个", menuItemTag: GYDownloadMenuItemStartTag + 100 + 2, maxConcurrentCount: 1, source: .panel)
    static let concurrent5Input = GYDownloadSetting(menuItemTitle: "同时下载5个", menuItemTag: GYDownloadMenuItemStartTag + 100 + 3, maxConcurrentCount: 5, source: .input)
    static let concurrent5Panel = GYDownloadSetting(menuItemTitle: "同时下载5个", menuItemTag: GYDownloadMenuItemStartTag + 100 + 4, maxConcurrentCount: 5, source: .panel)
    static let concurrent10Input = GYDownloadSetting(menuItemTitle: "同时下载10个", menuItemTag: GYDownloadMenuItemStartTag + 100 + 5, maxConcurrentCount: 10, source: .input)
    static let concurrent10Panel = GYDownloadSetting(menuItemTitle: "同时下载10个", menuItemTag: GYDownloadMenuItemStartTag + 100 + 6, maxConcurrentCount: 10, source: .panel)

    static let resourceSitesInput = GYDownloadSetting(menuItemTitle: "适用于 图站", menuItemTag: GYDownloadMenuItemStartTag + 200 + 1, maxConcurrentCount: 3, maxRedownloadTimes: 2, timeoutInterval: 15, source: .input)
    static let resourceSitesPanel = GYDownloadSetting(menuItemTitle: "适用于 图站", menuItemTag: GYDownloadMenuItemStartTag + 200 + 2, maxConcurrentCount: 3, maxRedownloadTimes: 2, timeoutInterval: 15, source: .panel)
    static let videoInput = GYDownloadSetting(menuItemTitle: "适用于 视频", menuItemTag: GYDownloadMenuItemStartTag + 200 + 3, maxConcurrentCount: 5, maxRedownloadTimes: 2, source: .input)
    static let videoPanel = GYDownloadSetting(menuItemTitle: "适用于 视频", menuItemTag: GYDownloadMenuItemStartTag + 200 + 4, maxConcurrentCount: 3, maxRedownloadTimes: 2, source: .panel)
}
