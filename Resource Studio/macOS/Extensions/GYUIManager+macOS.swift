//
//  GYUIManager+macOS.swift
//  Resource Studio
//
//  Created by 龚宇 on 22/06/17.
//

import Foundation
import AppKit

extension GYUIManager {
    class func imageSize(fromPath path: String) -> NSSize {
        let imageRep = NSImageRep(contentsOfFile: path)
        if imageRep == nil {
            return NSSize.zero
        } else {
            return NSSize(width: imageRep!.pixelsWide, height: imageRep!.pixelsHigh)
        }
    }
}
