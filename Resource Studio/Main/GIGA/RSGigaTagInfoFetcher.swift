//
//  RSGigaTagInfoFetcher.swift
//  Resource Studio
//
//  Created by 龚宇 on 22/05/14.
//

import Foundation
import hpple

protocol RSGigaTagInfoFetcherDelegate: AnyObject {
    func gigaTagInfoFetcherDidFinish()
}

// 使用方法
/**
 private var fetcher: RSGigaTagInfoFetcher? = RSGigaTagInfoFetcher(tagIDs: [366, 486])
 fetcher?.start(isFirstTag: true)
 
 // MARK: RSGigaTagInfoFetcherDelegate
 func gigaTagInfoFetcherDidFinish() {
    fetcher = nil
 }
 */

class RSGigaTagInfoFetcher {
    weak var delegate: RSGigaTagInfoFetcherDelegate?
    
    private let tasks = RSGigaTasks()
    
    private var tagIDs: [Int] // 标签ID
    
    private var currentTag = "" // 当前标签内容
    private var currentTotalPages = 0 // 当前标签一共多少页
    private var currentPage = 1 // 当前标签的页码，从1开始
    private var currentImageURLs: [String] = [] // 当前标签下的作品图片地址
    
    // MARK: Initial
    init(tagIDs: [Int]) {
        self.tagIDs = tagIDs
    }
    
    func start(isFirstTag: Bool) {
        if isFirstTag {
            GYLogManager.shared.addDefaultLog(format: "抓取 GIGA 官网标签数据, 流程开始")
        }
        
        currentTag = ""
        currentPage = 1
        currentTotalPages = 0
        currentImageURLs = []
        
        if tagIDs.count == 0 {
            // tagIDs 为空数组，说明抓取流程结束
            GYLogManager.shared.addDefaultLog(format: "抓取 GIGA 官网标签数据, 流程结束")
            
            delegate?.gigaTagInfoFetcherDidFinish()
        } else {
            // 抓取新的标签，需要清空记录
            let tagID = tagIDs.removeFirst()
            _fetchSingleTagBy(tagID: tagID, isFirstPage: true)
        }
    }
    
    // MARK: Fetch
    private func _fetchSingleTagBy(tagID: Int, isFirstPage: Bool) {
        // 如果不是第一页，那么 currentTotalPages 已经赋值了; 如果 currentPage > currentTotalPages，说明最后一页已经抓取完毕了
        if !isFirstPage && currentPage > currentTotalPages {
            // 抓取下一个标签
            start(isFirstTag: false)
            
            return
        }
        
        tasks.fetchTagBy(tagID: tagID, page: currentPage) { [weak self] (success, parser) in
            if success {
                // Componets
                self!.currentTotalPages = self!._currentTotalPagesFrom(parser: parser!)
                self!.currentTag = self!._currentTagFrom(parser: parser!)
                self!.currentImageURLs.append(contentsOf: self!._currentImageURLsFrom(parser: parser!))
                
                // Log
                GYLogManager.shared.addDefaultLog(format: "已成功抓取 GIGA 标签: %@, 共计 %ld 条记录", self!.currentTag, self!.currentImageURLs.count)
                
                // Export
                let folderPath = (GYBase.shared.downloadFolderPath as NSString).appendingPathComponent("GIGA Tags")
                GYFileManager.createFolder(atPath: folderPath)
                let txtFile = String(format: "%@.txt", self!.currentTag)
                let txtFilePath = (folderPath as NSString).appendingPathComponent(txtFile)
                self!.currentImageURLs.export(toPath: txtFilePath, continueWhenExist: false)
            } else {
                GYLogManager.shared.addErrorLog(format: "抓取 GIGA 标签: %@ 第 %ld 页时出现错误, 即将抓取下一页", self!.currentTag, self!.currentPage)
            }
            
            // 抓取下一页
            self!.currentPage += 1
            self!._fetchSingleTagBy(tagID: tagID, isFirstPage: false)
        }
    }
    
    // MARK: Parse
    private func _currentTotalPagesFrom(parser: TFHpple) -> Int {
        var divArray = parser.search(withXPathQuery: "//dl") as? [TFHppleElement]
        divArray = divArray?.filter({
            if let classObj = $0.attributes["class"], let classString = classObj as? String {
                return classString == "page mtx"
            } else {
                return false
            }
        })
        guard divArray != nil, divArray!.count > 0 else {
            return 0
        }
        
        let divElement = divArray!.first!
        var subElements: [TFHppleElement]? = divElement.children as? [TFHppleElement]
        subElements = subElements?.filter({
            if let textChild = $0.firstTextChild(), let content = textChild.content {
                return content.hasPrefix("全") && content.hasSuffix("件")
            } else {
                return false
            }
        })
        guard subElements != nil, subElements!.count > 0 else {
            return 0
        }
        
        var content = subElements!.first!.firstTextChild()!.content!
        content = content.replacingOccurrences(of: "全", with: "")
        content = content.replacingOccurrences(of: "件", with: "")
        let count = Int(content)!
        
        return Int(ceilf(Float(count) / 20))
    }
    private func _currentTagFrom(parser: TFHpple) -> String {
        var divArray = parser.search(withXPathQuery: "//div") as? [TFHppleElement]
        divArray = divArray?.filter({
            if let classObj = $0.attributes["class"], let classString = classObj as? String {
                let classBool = classString == "col s12 m12 l10 center"
                let contentBool = ($0.raw != nil) && $0.raw.contains("タグ検索")
                
                return classBool && contentBool
            } else {
                return false
            }
        })
        guard divArray != nil, divArray!.count > 0 else {
            return "未知标签"
        }
        
        let divElement = divArray!.first!
        var subElements: [TFHppleElement]? = divElement.children as? [TFHppleElement]
        subElements = subElements?.filter({ $0.isTextNode() && $0.content != nil && $0.content.contains("タグ検索") })
        guard subElements != nil, subElements!.count > 0 else {
            return "未知标签"
        }
        
        let textElement = subElements!.first!
        var text = textElement.content!
        text = text.replacingOccurrences(of: "【", with: "")
        text = text.replacingOccurrences(of: "】", with: "")
        text = text.replacingOccurrences(of: "　", with: "")
        text = text.replacingOccurrences(of: "\t", with: "")
        text = text.replacingOccurrences(of: "\n", with: "")
        text = text.replacingOccurrences(of: "\r", with: "")
        text = text.replacingOccurrences(of: "タグ検索", with: "")
        text = text.replacingOccurrences(of: "検索結果", with: "")
        
        return text
    }
    private func _currentImageURLsFrom(parser: TFHpple) -> [String] {
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
