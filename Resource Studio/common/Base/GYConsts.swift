//
//  GYCommonConst.swift
//  GYSwiftLib
//
//  Created by 龚宇 on 22/04/23.
//

import Foundation

// MARK: Time Format
let GYTimeFormatCompactyMd = "yyyyMMdd";
let GYTimeFormatCompactyMdHms = "yyyyMMddHHmmss";
let GYTimeFormatyMdHms = "yyyy-MM-dd HH:mm:ss";
let GYTimeFormatyMdHmsS = "yyyy-MM-dd HH:mm:ss.SSS";
let GYTimeFormatEMdHmsZy = "EEE MMM dd HH:mm:ss Z yyyy";

// MARK: Notification Keys
// 日志相关
// 以下通知都需要在主线程上跑：dispatch_main_async_safe((^{   }));
let GYLogCleanNotificationKey = "com.gongyu.GYSwiftLib.notification.keys.log.clean";
let GYLogScrollLatestNotificationKey = "com.gongyu.GYSwiftLib.notification.keys.log.scroll.latest";
let GYLogShowNotificationKey = "com.gongyu.GYSwiftLib.notification.keys.log.show";
