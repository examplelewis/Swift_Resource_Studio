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
        progressIndicatorMaxValue = 1.0
        
        GYAsyncSafe {
            self.viewController.progressIndicator.doubleValue = 0.0
            self.viewController.progressIndicator.maxValue = 1.0
            self.viewController.progressLabel.stringValue = "0 / 0"
        }
    }
    func updateProgressIndicatorMaxValue(_ value: Double) {
        progressIndicatorMaxValue = value
        
        GYAsyncSafe {
            self.viewController.progressIndicator.doubleValue = 0.0
            self.viewController.progressIndicator.maxValue = value
            self.viewController.progressLabel.stringValue = String(format: "0 / %.0f", value)
        }
    }
    func updateProgressIndicatorValue(_ value: Double) {
        GYAsyncSafe {
            self.viewController.progressIndicator.doubleValue = value
            self.viewController.progressLabel.stringValue = String(format: "%.0f / %.0f", value, self.progressIndicatorMaxValue)
        }
    }
}
