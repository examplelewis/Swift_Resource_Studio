//
//  RSJavLibraryActorFetcher.swift
//  Resource Studio
//
//  Created by 龚宇 on 22/05/21.
//

import Foundation
import hpple

protocol RSJavLibraryActorFetcherDelegate: AnyObject {
    func javLibraryActorFetcherDidFinish()
}

// 使用方法
/**
 private var fetcher: RSJavLibraryActorFetcher? = RSJavLibraryActorFetcher(keywords: ["paca"])
 fetcher?.delegate = self
 fetcher?.start(isFirstTag: true)
 
 // MARK: RSJavLibraryActorFetcherDelegate
 func javLibraryActorFetcherDidFinish() {
     fetcher = nil
 }
 */

class RSJavLibraryActorFetcher {
    weak var delegate: RSJavLibraryActorFetcherDelegate?
    
    private let tasks = RSJavLibraryTasks()
    
    private var keywords: [String] // 关键字
    
    private var currentTag = "" // 当前标签内容
    private var currentTotalPages = 0 // 当前标签一共多少页
    private var currentPage = 1 // 当前标签的页码，从1开始
    private var currentImageURLs: [String] = [] // 当前标签下的作品图片地址
    
    // MARK: Initial
    init(keywords: [String]) {
        self.keywords = keywords
    }
    deinit {
        print("deinit")
    }
    
    func start(isFirstTag: Bool) {
        if isFirstTag {
            GYLogManager.shared.addDefaultLog(format: "抓取 JAVLibrary 官网女优数据, 流程开始")
        }
        
        // 抓取新的标签，需要清空记录
        currentTag = ""
        currentPage = 1
        currentTotalPages = 0
        currentImageURLs = []
        
        if keywords.count == 0 {
            // tagIDs 为空数组，说明抓取流程结束
            GYLogManager.shared.addDefaultLog(format: "抓取 JAVLibrary 官网女优数据, 流程结束")
            
            delegate?.javLibraryActorFetcherDidFinish()
        } else {
            let keyword = keywords.removeFirst()
            _fetchSingleTagBy(keyword: keyword, isFirstPage: true)
        }
    }
    
    // MARK: Fetch
    private func _fetchSingleTagBy(keyword: String, isFirstPage: Bool) {
        // 如果不是第一页，那么 currentTotalPages 已经赋值了; 如果 currentPage > currentTotalPages，说明最后一页已经抓取完毕了
        if !isFirstPage && currentPage > currentTotalPages {
            // 抓取下一个标签
            start(isFirstTag: false)
            
            return
        }
        
        tasks.fetchActorBy(keyWord: keyword, page: currentPage) { [weak self] (success, parser) in
            if success {
                // Componets
                self!.currentTotalPages = self!._currentTotalPagesFrom(parser: parser!)
                self!.currentTag = self!._currentTagFrom(parser: parser!)
                self!.currentImageURLs.append(contentsOf: self!._currentImageURLsFrom(parser: parser!))
                
                // Log
                GYLogManager.shared.addDefaultLog(format: "已成功抓取 JAVLibrary 女优: %@, 共计 %ld 条记录", self!.currentTag, self!.currentImageURLs.count)
                
                // Export
                let folderPath = (GYBase.shared.downloadFolderPath as NSString).appendingPathComponent("JAVLibrary Actors")
                GYFileManager.createFolder(atPath: folderPath)
                let txtFile = String(format: "%@.txt", self!.currentTag)
                let txtFilePath = (folderPath as NSString).appendingPathComponent(txtFile)
                self!.currentImageURLs.export(toPath: txtFilePath, continueWhenExist: false)
            } else {
                GYLogManager.shared.addErrorLog(format: "抓取 JAVLibrary 女优: %@ 第 %ld 页时出现错误, 即将抓取下一页", self!.currentTag, self!.currentPage)
            }
            
            // 抓取下一页
            self!.currentPage += 1
            self!._fetchSingleTagBy(keyword: keyword, isFirstPage: false)
        }
    }
    
    // MARK: Parse
    private func _currentTotalPagesFrom(parser: TFHpple) -> Int {
        var aArray = parser.search(withXPathQuery: "//a") as? [TFHppleElement]
        aArray = aArray?.filter({
            if let classObj = $0.attributes["class"], let classString = classObj as? String {
                return classString == "page last"
            } else {
                return false
            }
        })
        guard aArray != nil, aArray!.count > 0 else {
            return 0
        }
        
        let aElement = aArray!.first!
        let href = aElement.attributes["href"] as! String
        let page = href.components(separatedBy: "=").last!
        
        return Int(page)!
    }
    private func _currentTagFrom(parser: TFHpple) -> String {
        var divArray = parser.search(withXPathQuery: "//div") as? [TFHppleElement]
        divArray = divArray?.filter({
            if let classObj = $0.attributes["class"], let classString = classObj as? String {
                return classString == "boxtitle"
            } else {
                return false
            }
        })
        guard divArray != nil, divArray!.count > 0 else {
            return "未知标签"
        }
        
        let divElement = divArray!.first!
        if divElement.children.count == 0 {
            return "未知标签"
        }
        
        let subElement = divElement.children.first as! TFHppleElement
        
        let components = subElement.content.components(separatedBy: " ")
        if components.first != nil {
            return components.first!
        } else {
            return "未知标签"
        }
    }
    private func _currentImageURLsFrom(parser: TFHpple) -> [String] {
        var divArray = parser.search(withXPathQuery: "//div") as? [TFHppleElement]
        divArray = divArray?.filter({
            if let classObj = $0.attributes["class"], let classString = classObj as? String {
                return classString == "video"
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
            subElements = subElements?.filter({ $0.attributes.keys.contains("href") })
            guard subElements != nil, subElements!.count > 0 else {
                continue
            }
            
            let subElement = subElements!.first!
            var imgElements: [TFHppleElement]? = subElement.children as? [TFHppleElement]
            imgElements = imgElements?.filter({ $0.attributes.keys.contains("src") })
            guard imgElements != nil, imgElements!.count > 0 else {
                continue
            }
            
            let imgElement = imgElements!.first!
            var imgSrc = imgElement.attributes["src"] as! String
            imgSrc = imgSrc.replacingOccurrences(of: "ps.jpg", with: "pl.jpg")
            
            imageURLs.append(imgSrc)
        }
        
        return imageURLs
    }
}
