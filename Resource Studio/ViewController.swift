//
//  ViewController.swift
//  Resource Studio
//
//  Created by 龚宇 on 22/05/04.
//

import Cocoa
import Alamofire

class ViewController: NSViewController {
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        RSUIManager.shared.viewController = self
    }
    
    // MARK: Actions
    @IBAction func tempButtonDidPress(_ sender: NSButton) {
        
    }
}

