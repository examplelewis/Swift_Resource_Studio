//
//  GYColorMacros+macOS.swift
//  Resource Studio
//
//  Created by 龚宇 on 22/06/17.
//

import Foundation
import AppKit

func GYColor(red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) -> NSColor {
//    let needGrey = false
//    if needGrey {
//        let grey = CGFloat(red) * 0.299 + CGFloat(green) * 0.587 + CGFloat(blue) * 0.114
//        return NSColor(red: CGFloat(grey) / 255.0, green: CGFloat(grey) / 255.0, blue: CGFloat(grey) / 255.0, alpha: alpha)
//    } else {
        return NSColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
//    }
}

func GYColor(_ hexString: String, _ alpha: CGFloat = 1.0) -> NSColor {
    let hexString = _GYSharpHexString(hexString: hexString)

    if alpha == 1.0 {
        if hexString.count == 7 {
            return _GYColor(hexString)
        } else if hexString.count == 9 {
            return GYColor(argbHexString: hexString)
        } else {
            return .black
        }
    } else {
        return _GYColor(hexString, alpha)
    }
}

func GYColor(rgbaHexString: String) -> NSColor {
    guard rgbaHexString.count == 9 else {
        return .black
    }

    let alphaInt = _GYUInt64(hexString: rgbaHexString[7, 2])
    let alphaFloat = CGFloat(alphaInt) / 255.0

    return _GYColor(rgbaHexString[1, 6], alphaFloat)
}
func GYColor(argbHexString: String) -> NSColor {
    guard argbHexString.count == 9 else {
        return .black
    }

    let alphaInt = _GYUInt64(hexString: argbHexString[1, 2])
    let alphaFloat = CGFloat(alphaInt) / 255.0

    return _GYColor(argbHexString[3, 6], alphaFloat)
}

fileprivate func _GYColor(_ hexString: String, _ alpha: CGFloat = 1.0) -> NSColor {
    let sharpHexString = _GYSharpHexString(hexString: hexString)
    guard sharpHexString.count == 7 else {
        return .black
    }

    let r = _GYUInt64(hexString: sharpHexString[1, 2])
    let g = _GYUInt64(hexString: sharpHexString[3, 2])
    let b = _GYUInt64(hexString: sharpHexString[5, 2])

    return GYColor(red: Int(r), green: Int(g), blue: Int(b), alpha: alpha)
}

fileprivate func _GYSharpHexString(hexString: String) -> String {
    var string = hexString
    if !string.hasPrefix("#") {
        string = String(format: "#%@", string)
    }
    
    return string
}
fileprivate func _GYUInt64(hexString: String) -> UInt64 {
    var uHexValue: UInt64 = 0
    let scanner = Scanner(string: hexString)
    scanner.scanHexInt64(&uHexValue)
    
    return uHexValue
}
