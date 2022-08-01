//
//  GYBase.swift
//  Resource Studio
//
//  Created by 龚宇 on 22/05/14.
//

import Foundation

class GYBase {
    static let shared = GYBase()
    
    var mimeImageTypes: [String] = ["3gp", "avi", "f4v", "flv", "mkv", "mov", "mp4", "mpeg", "mpg", "rm", "rmvb", "webm", "wmv"]
    var mimeAudioTypes: [String] = []
    var mimeVideoTypes: [String] = ["ai", "bmp", "cdr", "eps", "gif", "jpg", "jpeg", "png", "psd", "raw", "svg", "tif", "webp"]
    var mimeImgVidTypes: [String] { mimeImageTypes + mimeVideoTypes }
    var mimeMediaTypes: [String] { mimeImageTypes + mimeAudioTypes + mimeVideoTypes }
    
    // MARK: macOS
    var mainFolderPath = "" // macOS 使用的主文件夹路径
    
    func pathOfItemIsImage(_ path: String) -> Bool {
        for type in mimeImageTypes {
            if (path as NSString).pathExtension == type {
                return true
            }
        }
        
        return false
    }
    func pathOfItemIsVideo(_ path: String) -> Bool {
        for type in mimeVideoTypes {
            if (path as NSString).pathExtension == type {
                return true
            }
        }
        
        return false
    }
}
