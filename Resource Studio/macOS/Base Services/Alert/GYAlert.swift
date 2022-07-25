//
//  GYAlert.swift
//  Resource Studio
//
//  Created by jsyh on 2022/7/20.
//

import Cocoa

enum GYAlertKeyEquivalent: String {
    case returnKey = "\r"
    case escapeKey = "\033"
}

class GYAlert: NSAlert {
    var isRunModal = false
    var response = NSApplication.ModalResponse(rawValue: 0)
    
    var textView: NSTextView?
    private var clipView: NSClipView?
    private var scrollView: NSScrollView?
    
    func addButton(withTitles titles: [String], keyEquivalents: [GYAlertKeyEquivalent]) {
        let minCount = min(titles.count, keyEquivalents.count)
        for index in 0..<minCount {
            addButton(withTitle: titles[index])
            buttons[index].keyEquivalent = keyEquivalents[index].rawValue
        }
    }
    func addTextView(byFrame frame: NSRect = NSRect(x: 0, y: 0, width: 400, height: 300)) {
        textView = NSTextView(frame: frame)
        textView!.autoresizingMask = [.width, .height]
        
        clipView = NSClipView(frame: frame)
        clipView!.autoresizingMask = [.width, .height]
        clipView!.documentView = textView
        
        scrollView = NSScrollView(frame: frame)
        scrollView!.hasVerticalScroller = true
        scrollView!.contentView = clipView!
        
        accessoryView = scrollView
    }
}
