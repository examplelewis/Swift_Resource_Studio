//
//  GYDownloadManager.swift
//  Resource Studio
//
//  Created by 龚宇 on 22/05/14.
//

import Foundation

protocol GYDownloadManagerDelegate: AnyObject {
    func downloadManagerDidFinish()
}

class GYDownloadManager: GYDownloaderDelegate {
    weak var delegate: GYDownloadManagerDelegate?
    
    var source: GYDownloadSource = .input
    var baseSetting: GYDownloadSetting
    var txtFilePaths: [String]? // 批量下载，获取到的 txt 文件路径
    var downloaders: [GYDownloader] = [] // 下载器
    
    init(baseSetting: GYDownloadSetting, itemPaths: [String]) {
        self.source = .panel
        self.baseSetting = baseSetting
        self.txtFilePaths = itemPaths
    }
    
    func start() {
        if source == .input {
            startInput()
        } else {
            startPanel(isFirst: true)
        }
    }
    private func startInput() {
        
    }
    private func startPanel(isFirst: Bool) {
        if isFirst {
            GYLogManager.shared.addDefaultLog(format: "批量下载 txt 文件内资源，流程开始")
        }
        
        if txtFilePaths!.count == 0 {
            txtFilePaths = []
            downloaders = []
            
            GYLogManager.shared.addDefaultLog(format: "所有 txt 文件内的资源已全部下载完成")
            GYLogManager.shared.addDefaultLog(format: "批量下载 txt 文件内资源，流程结束")
            
            delegate?.downloadManagerDidFinish()
        } else {
            let newSetting = baseSetting
            let txtFilePath = txtFilePaths!.removeFirst()
            
            // 更新下载文件夹的路径
            let txtFileName = ((txtFilePath as NSString).lastPathComponent as NSString).deletingPathExtension
            newSetting.folderPath = (GYBase.shared.downloadFolderPath as NSString).appendingPathComponent(txtFileName)
            
            // 获取 txt 文件里的内容并开始下载；若无法获取，获取下一个
            do {
                let URLString = try String(contentsOfFile: txtFilePath, encoding: .utf8)
                if URLString.count == 0 {
                    GYLogManager.shared.addWarningLog(format: "未读取到可用的下载链接, 读取下一个文件")
                    
                    startPanel(isFirst: false)
                } else {
                    let URLs = URLString.components(separatedBy: "\n")
                    let downloader = GYDownloader(setting: newSetting, URLs: URLs, txtFilePath: txtFilePath)
                    downloader.delegate = self
                    downloader.start()
                    
                    downloaders.append(downloader)
                }
            } catch {
                GYLogManager.shared.addWarningLog(format: "读取TXT文件失败: %@, 读取下一个文件", error.localizedDescription)
                
                startPanel(isFirst: false)
            }
        }
    }
    
    // MARK: GYDownloaderDelegate
    func downloaderDidFinish(_ downloader: GYDownloader) {
        let txtFileName = (((downloader.txtFilePath ?? "") as NSString).lastPathComponent as NSString).deletingPathExtension
        GYLogManager.shared.addDefaultLog(format: "%@ 已经下载完成", txtFileName)
        
        if let index = downloaders.firstIndex(of: downloader) {
            downloaders.remove(at: index)
        }
        
        startPanel(isFirst: false)
    }
}
