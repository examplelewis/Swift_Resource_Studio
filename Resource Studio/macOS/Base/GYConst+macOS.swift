//
//  GYConst+macOS.swift
//  Resource Studio
//
//  Created by 龚宇 on 22/05/17.
//

import Foundation

// MARK: Open Panel
struct GYOpenPanelBehavior: OptionSet {
    let rawValue: Int
    
    // None
    static let none = GYOpenPanelBehavior([])
    
    // Choose
    static let chooseFile = GYOpenPanelBehavior(rawValue: 1 << 0)
    static let chooseFolder = GYOpenPanelBehavior(rawValue: 1 << 1)
    
    // Other
    static let createFolder = GYOpenPanelBehavior(rawValue: 1 << 2)
    static let multiple = GYOpenPanelBehavior(rawValue: 1 << 3)
    static let showHidden = GYOpenPanelBehavior(rawValue: 1 << 4)
    
    // Combine
    static let singleFile: GYOpenPanelBehavior = [.chooseFile]
    static let singleFolder: GYOpenPanelBehavior = [.chooseFolder]
    static let singleItem: GYOpenPanelBehavior = [.singleFile, singleFolder]
    
    static let multipleFile: GYOpenPanelBehavior = [.chooseFile, .multiple]
    static let multipleFolder: GYOpenPanelBehavior = [.chooseFolder, .multiple]
    static let multipleItem: GYOpenPanelBehavior = [.singleItem, .multiple]
}
enum GYOpenPanelWindowType: Int {
    case mainWindow
    case keyWindow
    case customWindow
}
