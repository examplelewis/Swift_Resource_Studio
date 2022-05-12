//
//  GYMacros.swift
//  Resource Studio
//
//  Created by 龚宇 on 22/05/12.
//

import Foundation

func GYSynchronized(_ lock: Any, closure: () -> Void) {
    objc_sync_enter(lock)
    closure()
    objc_sync_exit(lock)
}
