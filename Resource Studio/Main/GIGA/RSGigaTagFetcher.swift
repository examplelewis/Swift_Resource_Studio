//
//  RSGigaTagFetcher.swift
//  Resource Studio
//
//  Created by 龚宇 on 22/05/14.
//

import Foundation
import hpple

protocol RSGigaTagFetcherDelegate: AnyObject {
    func gigaTagInfoFetcherDidFinish()
}

// 使用方法
/**
 private var fetcher: RSGigaTagFetcher? = RSGigaTagFetcher(tagIDs: ["31717", "92", "412", "353", "494", "481", "31691", "545", "30829", "31631", "31399", "30219", "30495", "227", "31624", "31710", "73", "31783", "31597", "487", "37", "31628", "31695", "31694", "232", "35", "31834", "30710", "32027", "31720", "31694", "459", "30600", "300", "201", "30629", "519", "30013", "30023", "30553", "31616", "363", "30300", "486", "96"])
 fetcher?.delegate = self
 fetcher?.start(isFirstTag: true)
 
 // MARK: RSGigaTagFetcherDelegate
 func gigaTagInfoFetcherDidFinish() {
    fetcher = nil
 }
 */

class RSGigaTagFetcher {
    weak var delegate: RSGigaTagFetcherDelegate?
    
    private let tasks = RSGigaTasks()
    
    private var tagIDs: [String] // 标签ID
    
    private var currentTag = "" // 当前标签内容
    private var currentTagID = "" // 当前标签ID
    private var currentTotalPages = 0 // 当前标签一共多少页
    private var currentPage = 1 // 当前标签的页码，从1开始
    private var currentImageURLs: [String] = [] // 当前标签下的作品图片地址
    private var currentWorks: [RSGigaWork] = [] // 当前标签下的作品
    
    // MARK: Initial
    init(tagIDs: [String]) {
        self.tagIDs = tagIDs
    }
    
    func start(isFirstTag: Bool) {
        if isFirstTag {
            GYLogManager.shared.addDefaultLog(format: "抓取 GIGA 官网标签数据, 流程开始")
        }
        
        // 抓取新的标签，需要清空记录
        currentTag = ""
        currentTagID = ""
        currentPage = 1
        currentTotalPages = 0
        currentImageURLs = []
        currentWorks = []
        
        if tagIDs.count == 0 {
            // tagIDs 为空数组，说明抓取流程结束
            GYLogManager.shared.addDefaultLog(format: "抓取 GIGA 官网标签数据, 流程结束")
            
            delegate?.gigaTagInfoFetcherDidFinish()
        } else {
            currentTagID = tagIDs.removeFirst()
            _fetchSingleTagBy(isFirstPage: true)
        }
    }
    
    // MARK: Fetch
    private func _fetchSingleTagBy(isFirstPage: Bool) {
        // 如果不是第一页，那么 currentTotalPages 已经赋值了; 如果 currentPage > currentTotalPages，说明最后一页已经抓取完毕了
        if !isFirstPage && currentPage > currentTotalPages {
            // 往数据库里存当前标签的数据
            RSSitesDatabaseManager.shared.insertGiga(tag: currentTag, input: currentTagID, count: currentWorks.count)
            RSSitesDatabaseManager.shared.insertGiga(works: currentWorks)
            
            // 抓取下一个标签
            start(isFirstTag: false)
            
            return
        }
        
        tasks.fetchTagBy(tagID: currentTagID, page: currentPage) { [weak self] (success, parser) in
            if success {
                // Componets
                if self!.currentTotalPages == 0 {
                    self!.currentTotalPages = self!._currentTotalPagesFrom(parser: parser!)
                }
                if self!.currentTag.count == 0 {
                    self!.currentTag = self!._currentTagFrom(parser: parser!)
                }
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
            self!._fetchSingleTagBy(isFirstPage: false)
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
            guard let workImageURL = _workImageURLFrom(element: div) else {
                continue
            }
            guard let (workName, workURL) = _workNameAndURLFrom(element: div) else {
                continue
            }
            
            let work = RSGigaWork()
            work.tagName = currentTag
            work.name = workName
            work.URL = workURL
            work.imageURL = workImageURL
            
            imageURLs.append(workImageURL)
            currentWorks.append(work)
        }
        
        return imageURLs
    }
    private func _workImageURLFrom(element: TFHppleElement) -> String? {
        var subElements: [TFHppleElement]? = element.children as? [TFHppleElement]
        subElements = subElements?.filter({
            if let classObj = $0.attributes["class"], let classString = classObj as? String {
                return classString == "search_sam_box"
            } else {
                return false
            }
        })
        guard subElements != nil, subElements!.count > 0 else {
            return nil
        }
        
        let subElement = subElements!.first!
        var textElements: [TFHppleElement]? = subElement.children as? [TFHppleElement]
        textElements = textElements?.filter({ $0.isTextNode() && $0.content != nil && $0.content.contains("（") && $0.content.contains("）") })
        guard textElements != nil, textElements!.count > 0 else {
            return nil
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
        
        return String(format: "https://www.giga-web.jp/db_titles/%@/%@%@/pac_s.jpg", series.lowercased(), series.lowercased(), number)
    }
    private func _workNameAndURLFrom(element: TFHppleElement) -> (String, String)? {
        var subElements: [TFHppleElement]? = element.children as? [TFHppleElement]
        subElements = subElements?.filter({
            if let classObj = $0.attributes["class"], let classString = classObj as? String {
                return classString == "search_sam_box"
            } else {
                return false
            }
        })
        guard subElements != nil, subElements!.count > 0 else {
            return nil
        }
        
        let subElement = subElements!.first!
        var aElements: [TFHppleElement]? = subElement.children as? [TFHppleElement]
        aElements = aElements?.filter({ $0.attributes.keys.contains("href") })
        guard aElements != nil, aElements!.count > 0 else {
            return nil
        }
        
        let aElement = aElements!.first!
        let URL = String(format: "https://www.giga-web.jp/%@", aElement.attributes["href"] as! String)
        let name = aElement.firstChild.firstTextChild().content!
        
        return (URL, name)
    }
}
