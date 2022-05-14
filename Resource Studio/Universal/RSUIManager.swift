//
//  RSUIManager.swift
//  Resource Studio
//
//  Created by 龚宇 on 22/05/14.
//

import Foundation

class RSUIManager {
    static let shared = RSUIManager()
    
    var appDelegate = AppDelegate()
    var windowController = WindowController()
    var viewController = ViewController()
    
    private var progressIndicatorMaxValue: Double = 1.0
    
    // MARK: Progress Indicator
    func resetProgressIndicator() {
        
    }
    func updateProgressIndicatorMaxValue(_ value: Double) {
        
    }
    func updateProgressIndicatorValue(_ value: Double) {
        
    }
}
