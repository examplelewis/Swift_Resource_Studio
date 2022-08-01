//
//  RSDBExHentaiDatabase.swift
//  Resource Studio
//
//  Created by 龚宇 on 22/08/01.
//

import Foundation
import FMDB

class RSDBExHentaiDatabase {
    static let shared = RSDBExHentaiDatabase()
    
    private let queue = FMDatabaseQueue(path: GYBase.shared.pathOfSqlite("ExHentai"))!
}
