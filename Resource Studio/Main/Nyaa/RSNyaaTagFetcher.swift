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
                GYLogManager.shared.addDefaultLog(format: "已成功抓取 Nyaa 标签: %@, 共计 %ld 条记录", self!.currentTag, self!.currentMagnetURLs.count)
                
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
        var divArray = parser.search(withXPathQuery: "//div") as? [TFHppleElement]
        divArray = divArray?.filter({
            if let classObj = $0.attributes["class"], let classString = classObj as? String {
                return classString == "col s6 m4 l3 center thumBox"
            } else {
                return false
            }
        })
        guard divArray != nil, divArray!.count > 0 else {
            return []
        }
        
        var imageURLs: [String] = []
        for div in divArray! {
            var subElements: [TFHppleElement]? = div.children as? [TFHppleElement]
            subElements = subElements?.filter({
                if let classObj = $0.attributes["class"], let classString = classObj as? String {
                    return classString == "search_sam_box"
                } else {
                    return false
                }
            })
            guard subElements != nil, subElements!.count > 0 else {
                continue
            }
            
            let subElement = subElements!.first!
            var textElements: [TFHppleElement]? = subElement.children as? [TFHppleElement]
            textElements = textElements?.filter({ $0.isTextNode() && $0.content != nil && $0.content.contains("（") && $0.content.contains("）") })
            guard textElements != nil, textElements!.count > 0 else {
                continue
            }
            
            let textElement = textElements!.first!
            var content = textElement.content!
            content = content.replacingOccurrences(of: "（", with: "")
            content = content.replacingOccurrences(of: "）", with: "")
            content = content.replacingOccurrences(of: "\t", with: "")
            content = content.replacingOccurrences(of: "\n", with: "")
            content = content.replacingOccurrences(of: "\r", with: "")
            content = content.replacingOccurrences(of: "　", with: "")
            
            let components = content.components(separatedBy: "-")
            let series = components.first!
            let number = components.last!
            let url = String(format: "https://www.giga-web.jp/db_titles/%@/%@%@/pac_s.jpg", series.lowercased(), series.lowercased(), number)
            
            imageURLs.append(url)
        }
        
        return imageURLs
    }
}
