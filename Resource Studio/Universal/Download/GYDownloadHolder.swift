//
//  GYDownloadHolder.swift
//  Resource Studio
//
//  Created by 龚宇 on 22/05/14.
//

import Foundation

class GYDownloadHolder: GYDownloaderDelegate, GYDownloadManagerDelegate {
    static let shared = GYDownloadHolder()
    
    private var managers: [GYDownloadManager] = []
    private var downloaders: [GYDownloader] = []
    
    func add(downloader: GYDownloader) {
        downloader.delegate = self
        downloaders.append(downloader)
    }
    func add(manager: GYDownloadManager) {
        manager.delegate = self
        managers.append(manager)
    }
    
    // MARK: GYDownloaderDelegate
    func downloaderDidFinish(_ downloader: GYDownloader) {
        if let index = downloaders.firstIndex(of: downloader) {
            downloaders.remove(at: index)
        }
    }
    
    // MARK: GYDownloadManagerDelegate
    func downloadManagerDidFinish(_ manager: GYDownloadManager) {
        if let index = managers.firstIndex(of: manager) {
            managers.remove(at: index)
        }
    }
}
