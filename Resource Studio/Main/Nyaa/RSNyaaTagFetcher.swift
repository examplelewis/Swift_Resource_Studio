//
//  RSNyaaTagFetcher.swift
//  Resource Studio
//
//  Created by 龚宇 on 22/05/22.
//

import Foundation
import hpple

protocol RSNyaaTagFetcherDelegate: AnyObject {
    func nyaaTagFetcherDidFinish()
}

// 使用方法
/**
 private var fetcher: RSNyaaTagFetcher? = RSNyaaTagFetcher(tags: ["SWAG"])
 fetcher?.delegate = self
 fetcher?.start(isFirstTag: true)
 
 // MARK: RSNyaaTagFetcherDelegate
 func nyaaTagFetcherDidFinish() {
    fetcher = nil
 }
 */

class RSNyaaTagFetcher {
    weak var delegate: RSNyaaTagFetcherDelegate?
    
    private let tasks = RSNyaaTasks()
    
    private var tags: [String] // 标签ID
    
    private var currentTag = "" // 当前标签内容
    private var currentTotalPages = 0 // 当前标签一共多少页
    private var currentPage = 1 // 当前标签的页码，从1开始
    private var currentMagnetURLs: [String] = [] // 当前标签下的作品磁力链接地址
    private var currentWorks: [RSNyaaWork] = [] // 当前标签下的作品
    
    // MARK: Initial
    init(tags: [String]) {
        self.tags = tags
    }
    
    func start(isFirstTag: Bool) {
        if isFirstTag {
            GYLogManager.shared.addDefaultLog(format: "抓取 Nyaa 标签数据, 流程开始")
        }
        
        // 抓取新的标签，需要清空记录
        currentTag = ""
        currentPage = 1
        currentTotalPages = 0
        currentMagnetURLs = []
        currentWorks = []
        
        if tags.count == 0 {
            // tags 为空数组，说明抓取流程结束
            GYLogManager.shared.addDefaultLog(format: "抓取 Nyaa 标签数据, 流程结束")
            
            delegate?.nyaaTagFetcherDidFinish()
        } else {
            currentTag = tags.removeFirst()
            _fetchSingleTagBy(isFirstPage: true)
        }
    }
    
    // MARK: Fetch
    private func _fetchSingleTagBy(isFirstPage: Bool) {
        // 如果不是第一页，那么 currentTotalPages 已经赋值了; 如果 currentPage > currentTotalPages，说明最后一页已经抓取完毕了
        if !isFirstPage && currentPage > currentTotalPages {
            // 往数据库里存当前标签的数据
            RSSitesDatabaseManager.shared.insertNyaa(tag: currentTag, count: currentWorks.count)
            RSSitesDatabaseManager.shared.insertNyaa(works: currentWorks)
            
            // 抓取下一个标签
            start(isFirstTag: false)
            
            return
        }
        
        tasks.fetchTagBy(tag: currentTag, page: currentPage) { [weak self] (success, parser) in
            if success {
                // Componets
                self!.currentTotalPages = self!._currentTotalPagesFrom(parser: parser!)
                self!.currentMagnetURLs.append(contentsOf: self!._currentMagnetURLsFrom(parser: parser!))
                
                // Log
                GYLogManager.shared.addDefaultLog(format: "已成功抓取 Nyaa 标签: %@, 第 %ld 页, 共 %ld 页, 共计 %ld 条记录", self!.currentTag, self!.currentPage, self!.currentTotalPages, self!.currentMagnetURLs.count)
                
                // Export
                let folderPath = (GYBase.shared.downloadFolderPath as NSString).appendingPathComponent("Nyaa Tags")
                GYFileManager.createFolder(atPath: folderPath)
                let txtFile = String(format: "%@.txt", self!.currentTag)
                let txtFilePath = (folderPath as NSString).appendingPathComponent(txtFile)
                self!.currentMagnetURLs.export(toPath: txtFilePath, continueWhenExist: false)
            } else {
                GYLogManager.shared.addErrorLog(format: "抓取 Nyaa 标签: %@ 第 %ld 页时出现错误, 即将抓取下一页", self!.currentTag, self!.currentPage)
            }
            
            // 抓取下一页
            self!.currentPage += 1
            self!._fetchSingleTagBy(isFirstPage: false)
        }
    }
    
    // MARK: Parse
    private func _currentTotalPagesFrom(parser: TFHpple) -> Int {
        var ulArray = parser.search(withXPathQuery: "//ul") as? [TFHppleElement]
        ulArray = ulArray?.filter({
            if let classObj = $0.attributes["class"], let classString = classObj as? String {
                return classString == "pagination"
            } else {
                return false
            }
        })
        guard ulArray != nil, ulArray!.count > 0 else {
            return 0
        }
        
        let ulElement = ulArray!.first!
        let uiElements: [TFHppleElement]? = ulElement.children as? [TFHppleElement]
        guard uiElements != nil, uiElements!.count > 1 else {
            return 0
        }
        
        let lastPageElement = uiElements![uiElements!.count - 2]
        let aElements: [TFHppleElement]? = lastPageElement.children as? [TFHppleElement]
        guard aElements != nil, aElements!.count > 0 else {
            return 0
        }
        
        return Int(aElements!.first!.firstTextChild()!.content)!
    }
    private func _currentMagnetURLsFrom(parser: TFHpple) -> [String] {
        var trArray = parser.search(withXPathQuery: "//tr") as? [TFHppleElement]
        trArray = trArray?.filter({
            if let classObj = $0.attributes["class"], let classString = classObj as? String {
                return classString == "default"
            } else {
                return false
            }
        })
        guard trArray != nil, trArray!.count > 0 else {
            return []
        }
        
        var magnets: [String] = []
        for tr in trArray! {
            guard let (workName, workURL, workMagnet, workTorrent) = _workComponentsFrom(element: tr) else {
                continue
            }
            
            let work = RSNyaaWork()
            work.tagName = currentTag
            work.name = workName
            work.URL = workURL
            work.magnet = workMagnet
            work.torrent = workTorrent
            
            if workMagnet != nil {
                magnets.append(workMagnet!)
            }
            currentWorks.append(work)
        }
        
        return magnets
    }
    private func _workComponentsFrom(element: TFHppleElement) -> (String, String, String?, String?)? {
        if element.children.count < 3 {
            return nil
        }
        
        let fourthElement = element.children[3] as! TFHppleElement
        guard let linkTitleElement = fourthElement.children[1] as? TFHppleElement else {
            return nil
        }
        guard let workName = linkTitleElement.attributes["title"] as? String else {
            return nil
        }
        guard var workURL = linkTitleElement.attributes["href"] as? String else {
            return nil
        }
        workURL = String(format: "https://sukebei.nyaa.si%@", workURL)
        
        var workTorrent: String?
        var workMagnet: String?
        let sixthElement = element.children[5] as! TFHppleElement
        if let torrentElement = sixthElement.children[1] as? TFHppleElement {
            workTorrent = torrentElement.attributes["href"] as? String
            if workTorrent != nil {
                workTorrent = String(format: "https://sukebei.nyaa.si%@", workTorrent!)
            }
        }
        if let magnetElement = sixthElement.children[3] as? TFHppleElement {
            workMagnet = magnetElement.attributes["href"] as? String
        }
        
        return (workName, workURL, workMagnet, workTorrent)
    }
}
