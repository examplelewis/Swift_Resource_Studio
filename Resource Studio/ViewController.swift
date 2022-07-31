//
//  ViewController.swift
//  Resource Studio
//
//  Created by 龚宇 on 22/05/04.
//

import Cocoa
import Alamofire

class ViewController: NSViewController {
    @IBOutlet var inputTextView: NSTextView!
    @IBOutlet var logTextView: NSTextView!
    @IBOutlet var progressIndicator: NSProgressIndicator!
    @IBOutlet var progressLabel: NSTextField!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNotifications()
        setupUIAndData()
    }
    override func viewDidAppear() {
        super.viewDidAppear()
        
        NSApplication.shared.mainWindow?.makeFirstResponder(inputTextView)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Configure
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(showLog(withNotification:)), name: NSNotification.Name(rawValue: GYLogShowNotificationKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(cleanLog(withNotification:)), name: NSNotification.Name(rawValue: GYLogCleanNotificationKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showLatestLog(withNotification:)), name: NSNotification.Name(rawValue: GYLogScrollLatestNotificationKey), object: nil)
    }
    private func setupUIAndData() {
        inputTextView.setFont(.systemFont(ofSize: 12.0), range: NSMakeRange(0, 0))
        logTextView.setFont(.systemFont(ofSize: 12.0), range: NSMakeRange(0, 0))
        
        RSUIManager.shared.viewController = self
    }
    
    // MARK: Actions
    @IBAction private func exportButtonDidPress(_ sender: NSButton) {
        if inputTextView.string.count > 0 {
            inputTextView.string.export(toPath: GYBase.shared.pathOfItemInDownloadFolder("RSInput.txt"))
        } else {
            GYLogManager.shared.addDefaultLog(behavior: .onViewTimeAppend, format: "没有可导出的输入")
        }
    }
    @IBAction private func tempButtonDidPress(_ sender: NSButton) {
        
    }
    @IBAction private func cleanButtonDidPress(_ sender: NSButton) {
        GYLogManager.shared.clean()
    }
    
    // MARK: Notifications
    @objc func showLog(withNotification notification: Notification) {
        GYAsyncSafe {
            self._showLog(withNotification: notification)
        }
    }
    private func _showLog(withNotification notification: Notification) {
        guard let log = notification.object as? GYLog else {
            return
        }
        if !log.shouldAppend && log.latestLog == nil {
            return
        }
        guard let textStorage = logTextView.textStorage else {
            return
        }
        
        if log.shouldAppend {
            // 如果不是第一行的话，那么添加一个空行
            if textStorage.length != 0 {
                textStorage.append(NSAttributedString(string: "\n", attributes: [.foregroundColor: NSColor.labelColor]))
            }
            
            textStorage.append(log.attributedLog)
        } else {
            let range = (textStorage.string as NSString).range(of: log.latestLog!)
            textStorage.replaceCharacters(in: range, with: log.attributedLog)
        }
    }
    @objc func cleanLog(withNotification notification: Notification) {
        GYAsyncSafe {
            self.logTextView.string = ""
        }
    }
    @objc func showLatestLog(withNotification notification: Notification) {
        GYAsyncSafe {
            self.logTextView.scrollRangeToVisible(NSMakeRange(self.logTextView.string.count, 0))
        }
    }
    }
}

