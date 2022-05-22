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
        queue = FMDatabaseQueue(path: GYBase.shared.sqliteFilePath("Resources"))!
    }
    
    // MARK: GIGA tags
    func insertGiga(tag: String, input: String, count: Int) {
        let url = String(format: "https://www.giga-web.jp/search/index.php?year=&month=&day=&narrow=&salesform_id=&tag_id=%@&actor_id=&series_id=&label_id=&sort=1&s_type=&keyword=", input)
        
        queue.inDatabase { db in
           let success = db.executeUpdate("INSERT INTO giga_tags (input, url, name, count, time) values(?, ?, ?, ?, ?)", withArgumentsIn: [input, url, tag, count, Date.current().string()])
            
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
           let success = db.executeUpdate("INSERT INTO jav_library_tags (input, url, name, count, time) values(?, ?, ?, ?, ?)", withArgumentsIn: [input, url, tag, count, Date.current().string()])
            
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
}
