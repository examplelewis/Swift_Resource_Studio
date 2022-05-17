//
//  ViewController.swift
//  Resource Studio
//
//  Created by 龚宇 on 22/05/04.
//

import Cocoa
import Alamofire

class ViewController: NSViewController, RSGigaTagInfoFetcherDelegate {
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        RSUIManager.shared.viewController = self
    }
    
    @IBAction func tempButtonDidPress(_ sender: NSButton) {
        
    }
    
    // MARK: RSGigaTagInfoFetcherDelegate
    func gigaTagInfoFetcherDidFinish() {
        fetcher = nil
    }
}

