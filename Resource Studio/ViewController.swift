//
//  ViewController.swift
//  Resource Studio
//
//  Created by 龚宇 on 22/05/04.
//

import Cocoa
import Alamofire

class ViewController: NSViewController, RSGigaTagInfoFetcherDelegate {
    var fetcher: RSGigaTagInfoFetcher?
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        RSUIManager.shared.viewController = self
    }
    
    @IBAction func tempButtonDidPress(_ sender: NSButton) {
        fetcher = RSGigaTagInfoFetcher(tagIDs: [366, 486, 232, 31616, 30013, 494, 487, 31720, 35, 353, 459, 31717, 92, 212, 30553, 31597, 32027, 37, 227, 30629, 31834, 481, 31694, 30219, 545, 96, 30829, 363, 31631, 31624, 31710, 30023, 31628, 412, 30600, 201, 300, 519, 30710, 31691, 30495, 30300, 31695, 73, 31783])
        fetcher?.start(isFirstTag: true)
    }
    
    // MARK: RSGigaTagInfoFetcherDelegate
    func gigaTagInfoFetcherDidFinish() {
        fetcher = nil
    }
}

