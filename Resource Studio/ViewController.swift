//
//  ViewController.swift
//  Resource Studio
//
//  Created by 龚宇 on 22/05/04.
//

import Cocoa
import Alamofire

class ViewController: NSViewController {
    let gigaTasks = GYGigaTasks()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func tempButtonDidPress(_ sender: NSButton) {
        gigaTasks.fetchTagBy(id: 31720)
    }
}

