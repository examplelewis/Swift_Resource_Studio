//
//  GYDownloadManager.swift
//  Resource Studio
//
//  Created by 龚宇 on 22/05/14.
//

import Foundation
import Alamofire

protocol GYDownloadDelegate {
    func downloadManagerDidFinish(_ manager: GYDownloadManager)
}

class GYDownloadManager {
    var delegate: GYDownloadDelegate?
    
    private let setting: GYDownloadSetting
    private var URLs: [String] // 输入的链接, 不会变
    private let txtFilePath: String? // 包含下载地址的 txt 文件路径
    
    private var redoTimes = 0 // 重新下载次数
    private var remainURLsFilePath = ""
    
    private var remains: [String] // 还未下载的链接
    private var successes: [String] // 下载成功的链接
    // URLs.count = successURLs.count + remainURLs.count;
    
    private let opQueue = OperationQueue()
    
    // MARK: Initial
    init(setting: GYDownloadSetting, URLs: [String], txtFilePath: String?) {
        self.setting = setting
        self.URLs = URLs
        self.txtFilePath = txtFilePath
        
        self.remains = URLs
        self.successes = []
        
        if self.setting.folderPath == GYBase.shared.downloadFolderPath {
            remainURLsFilePath = GYBase.shared.pathOfItemInDownloadFolder(GYDownloadRemainURLsFile)
        } else {
            var downloadSuffix = setting.folderPath.replacingOccurrences(of: GYBase.shared.downloadFolderPath, with: "")
            downloadSuffix = downloadSuffix.replacingOccurrences(of: "/", with: "-")
            let remainURLsFile = String(format: "GYDownloadRemainURLs %@.txt", downloadSuffix)
            remainURLsFilePath = GYBase.shared.pathOfItemInDownloadFolder(remainURLsFile)
        }
        
        opQueue.maxConcurrentOperationCount = setting.maxConcurrentCount
    }
    
    func start() {
        // 创建下载文件夹
        if GYFileManager.createFolder(atPath: setting.folderPath) {
            _start(isFirstTime: true)
        } else {
            GYLogManager.shared.addErrorLog(format: "%@ 文件夹不存在且创建失败, 下载流程结束", setting.folderPath)
        }
    }
    
    private func _start(isFirstTime: Bool) {
        if isFirstTime {
            RSUIManager.shared.updateProgressIndicatorMaxValue(Double(URLs.count))
            GYLogManager.shared.addDefaultLog(format: "下载流程开始，共 %ld 个文件", URLs.count)
        } else {
            GYLogManager.shared.addNewLineLog()
            GYLogManager.shared.addDefaultLog(format: "第 %ld 次重新下载未成功的文件，共 %ld 个", redoTimes, URLs.count)
        }
        
        let completionOp = BlockOperation { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                self?._finishAllOperations()
            }
        }
        
        for url in URLs {
            let op = BlockOperation { [weak self] in
                // Semaphore
                let s = DispatchSemaphore(value: 0)
                
                // Headers
                var httpHeaders: HTTPHeaders?
                if let headers = self!.setting.headers, headers.count > 0 {
                    httpHeaders = HTTPHeaders(headers)
                }
                
                // Download
                AF.download(url, headers: httpHeaders, requestModifier: { [weak self] (request) in
                    request.timeoutInterval = self!.setting.timeoutInterval
                }, to: { [weak self] (temporaryURL, response) in
                    var fileName = response.suggestedFilename
                    if let renameInfo = self!.setting.renameInfo, let rename = renameInfo[url] {
                        fileName = rename
                    }
                    var filePath = (self!.setting.folderPath as NSString).appendingPathComponent(fileName!)
                    filePath = GYFileManager.nonConflictItemPath(from: filePath)
                    let fileURL = URL(fileURLWithPath: filePath)
                    
                    return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
                }).response { [weak self] (response) in
                    if response.error == nil {
                        GYSynchronized(self!) {
                            self!.successes.append(url)
                            if let index = self!.remains.firstIndex(of: url) {
                                self!.remains.remove(at: index)
                            }
                            self!.remains.export(toPath: self!.remainURLsFilePath, behavior: .exportNoneLog)
                            
                            RSUIManager.shared.updateProgressIndicatorValue(Double(self!.successes.count))
                        }
                    } else {
                        GYLogManager.shared.addErrorLog(format: "链接: %@, 下载失败: %@，等待重新下载", url, response.error!.localizedDescription)
                    }
                    
                    // Signal
                    s.signal()
                }
                
                // Wait
                let _ = s.wait(timeout: .now() + self!.setting.timeoutInterval)
            }
            
            completionOp.addDependency(op)
            opQueue.addOperation(op)
        }
        
        opQueue.addOperation(completionOp)
    }
    
    private func _finishAllOperations() {
        if remains.count > 0 && redoTimes < setting.maxRedownloadTimes {
            GYLogManager.shared.addDefaultLog(format: "1秒后重新下载未成功的文件")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                self!.redoTimes += 1
                self!.URLs = self!.remains
                
                self!._start(isFirstTime: false)
            }
        } else {
            if remains.count == 0 {
                if GYFileManager.itemExists(atPath: remainURLsFilePath) {
                    GYFileManager.trashItem(atPath: remainURLsFilePath)
                }
            } else {
                GYLogManager.shared.addWarningLog(format: "有 %ld 个文件仍然无法下载，列表已导出到下载文件夹中的 %@ 文件中", remains.count, (remainURLsFilePath as NSString).lastPathComponent)
            }
            
            // 删除包含下载路径的 txt 文件
            if let txtFilePath = txtFilePath, GYFileManager.itemExists(atPath: txtFilePath) {
                GYFileManager.trashItem(atPath: txtFilePath)
            }
            
            GYLogManager.shared.addDefaultLog(format: "下载流程结束")
            if setting.showFinishAlert {
                // TODO: Show Alert
            }
            
            delegate?.downloadManagerDidFinish(self)
        }
    }
}
