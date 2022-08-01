//
//  RSDBMainDatabase.swift
//  Resource Studio
//
//  Created by 龚宇 on 22/08/01.
//

import Foundation
import FMDB

class RSDBMainDatabase {
    static let shared = RSDBMainDatabase()
    
    private let queue = FMDatabaseQueue(path: GYBase.shared.pathOfSqlite("Main"))!
}
