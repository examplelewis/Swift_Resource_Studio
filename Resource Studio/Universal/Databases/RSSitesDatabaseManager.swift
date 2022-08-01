//
//  RSSitesDatabaseManager.swift
//  Resource Studio
//
//  Created by 龚宇 on 22/05/22.
//

import Foundation
import FMDB

class RSSitesDatabaseManager {
    static let shared = RSSitesDatabaseManager()
    
    private let queue: FMDatabaseQueue
    
    // MARK: Init
    init() {
        queue = FMDatabaseQueue(path: GYBase.shared.pathOfSqlite("Resources"))!
    }
    
    // MARK: GIGA tags
    func insertGiga(tag: String, input: String, count: Int) {
        let url = String(format: "https://www.giga-web.jp/search/index.php?year=&month=&day=&narrow=&salesform_id=&tag_id=%@&actor_id=&series_id=&label_id=&sort=1&s_type=&keyword=", input)
        
        queue.inDatabase { db in
           let success = db.executeUpdate("INSERT INTO giga_tags (input, name, count, url, time) values(?, ?, ?, ?, ?)", withArgumentsIn: [input, tag, count, url, Date.current().string()])
            
            if success {
                GYLogManager.shared.addSuccessLog(format: "已向 giga_tags 添加标签: %@", tag)
            } else {
                GYLogManager.shared.addErrorLog(format: "向 giga_tags 添加标签: %@ 时发生错误: %@", tag, db.lastErrorMessage())
            }
        }
    }
    func insertGiga(works: [RSGigaWork]) {
        for work in works {
            queue.inDatabase { db in
                db.executeUpdate("INSERT INTO giga_works (tag_name, work_name, work_url, work_image_url, time) values(?, ?, ?, ?, ?)", withArgumentsIn: [work.tagName, work.name, work.URL, work.imageURL, Date.current().string()])
            }
        }
        
        GYLogManager.shared.addDefaultLog(format: "已向 giga_works 添加 %ld 条数据", works.count)
    }
    
    // MARK: JavLibrary Actor
    func insertJav(tag: String, input: String, count: Int) {
        let url = String(format: "https://www.javlibrary.com/cn/vl_star.php?&mode=2&s=%@", input)
        
        queue.inDatabase { db in
           let success = db.executeUpdate("INSERT INTO jav_library_tags (input, name, count, url, time) values(?, ?, ?, ?, ?)", withArgumentsIn: [input, tag, count, url, Date.current().string()])
            
            if success {
                GYLogManager.shared.addSuccessLog(format: "已向 jav_library_tags 添加标签: %@", tag)
            } else {
                GYLogManager.shared.addErrorLog(format: "向 jav_library_tags 添加标签: %@ 时发生错误: %@", tag, db.lastErrorMessage())
            }
        }
    }
    func insertJav(works: [RSJavLibraryWork]) {
        for work in works {
            queue.inDatabase { db in
                db.executeUpdate("INSERT INTO jav_library_works (tag_name, work_name, work_url, work_image_url, time) values(?, ?, ?, ?, ?)", withArgumentsIn: [work.tagName, work.name, work.URL, work.imageURL, Date.current().string()])
            }
        }
        
        GYLogManager.shared.addDefaultLog(format: "已向 jav_library_works 添加 %ld 条数据", works.count)
    }
    
    // MARK: Nyaa Tag
    func insertNyaa(tag: String, count: Int) {
        let url = String(format: "https://sukebei.nyaa.si/?f=0&c=0_0&q=%@", tag)
        
        queue.inDatabase { db in
           let success = db.executeUpdate("INSERT INTO nyaa_tags (input, name, count, url, time) values(?, ?, ?, ?, ?)", withArgumentsIn: [tag, tag, count, url, Date.current().string()])
            
            if success {
                GYLogManager.shared.addSuccessLog(format: "已向 nyaa_tags 添加标签: %@", tag)
            } else {
                GYLogManager.shared.addErrorLog(format: "向 nyaa_tags 添加标签: %@ 时发生错误: %@", tag, db.lastErrorMessage())
            }
        }
    }
    func insertNyaa(works: [RSNyaaWork]) {
        for work in works {
            queue.inDatabase { db in
                db.executeUpdate("INSERT INTO nyaa_works (tag_name, work_name, work_url, work_magnet, work_torrent, time) values(?, ?, ?, ?, ?, ?)", withArgumentsIn: [work.tagName, work.name, work.URL, work.magnet ?? "NULL", work.torrent ?? "NULL", Date.current().string()])
            }
        }
        
        GYLogManager.shared.addDefaultLog(format: "已向 nyaa_works 添加 %ld 条数据", works.count)
    }
    // 更新 nyaa work 的下载状态
    func updateNyaaWorkBy(magnet: String, for state: Int) {
        var workID = -1
        queue.inDatabase { db in
            let sql = String(format: "select id from nyaa_works where work_magnet like '%%%@%%'", magnet)
            let rs = try? db.executeQuery(sql, values: nil)
            if rs != nil {
                while rs!.next() {
                    workID = Int(rs!.int(forColumn: "id"))
                }
            }
            
            rs?.close()
        }
        
        if workID == -1 {
            GYLogManager.shared.addWarningLog(format: "未找到包含链接: %@ 的作品", magnet)
        } else if let stateDesc = _nyaaWorkStateDescBy(state: state) {
            queue.inDatabase { db in
                let sql = String(format: "UPDATE nyaa_works set state = %ld, state_desc = '%@' where id = %ld", state, stateDesc, workID)
                let success = db.executeUpdate(sql, withArgumentsIn: [])
                
                if success {
                    GYLogManager.shared.addSuccessLog(format: "已将包含链接: %@ 的作品标记为【%@】", magnet, stateDesc)
                } else {
                    GYLogManager.shared.addErrorLog(format: "将包含链接: %@ 的作品标记为【%@】时出现错误: %@", magnet, stateDesc, db.lastErrorMessage())
                }
            }
        } else {
            GYLogManager.shared.addErrorLog(format: "输入的状态 %ld 有误，无法找到对应描述", state)
        }
    }
}

extension RSSitesDatabaseManager {
    fileprivate func _nyaaWorkStateDescBy(state: Int) -> String? {
        switch state {
        case -10:
            return "这是合集，暂时不下载"
        case -5:
            return "迅雷违规，无法下载"
        case 0:
            return "待下载"
        case 1:
            return "正在下载"
        case 89:
            return "与已下载的重复，不下载"
        case 99:
            return "已下载"
        default:
            return nil
        }
    }
}
