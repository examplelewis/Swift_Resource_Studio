//
//  AppDelegate.swift
//  Resource Studio
//
//  Created by 龚宇 on 22/05/04.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var downloadRootMenuItem: NSMenuItem!
    
    @IBOutlet weak var buildTimeMenuItem: NSMenuItem!
    
    // MARK: NSApplicationDelegate
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        setupNotifications()
        setupBuild()
        setupBase()
        setupDownloads()
        
        RSUIManager.shared.appDelegate = self
    }
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true // 点击窗口左上方的关闭按钮退出应用程序
    }
    
    // MARK: Menu Item Actions
    func proceedMenuItemBy(tag: Int) {
        let sender = NSMenuItem()
        sender.tag = tag
        
        customMenuItemDidPress(sender)
    }
    @IBAction func customMenuItemDidPress(_ sender: NSMenuItem) {
        RSDispatchMenuItem(sender)
    }
    @IBAction func helpMenuItemDidPress(_ sender: NSMenuItem) {
        
    }
    @IBAction func openLogMenuItemDidPress(_ sender: NSMenuItem) {
        var logFilePaths = GYFileManager.filePaths(inFolder: GYBase.shared.logFolderPath)
        logFilePaths = logFilePaths.sorted(by: { $0 > $1 })
        
        if logFilePaths.count == 0 || !NSWorkspace.shared.open(URL(fileURLWithPath: logFilePaths.first!)) {
//            GYAlertConfigure *configure = [GYAlertConfigure criticalConfigureWithMessage:@"打开日志文件时发生错误，打开失败" info:nil];
//            [GYAlertManager showAlertOnMainWindowWithConfigure:configure handler:nil];
        }
    }
    @IBAction func openPreferenceMenuItemDidPress(_ sender: NSMenuItem) {
        
    }
    @IBAction func backupDatabasesMenuItemDidPress(_ sender: NSMenuItem) {
        
    }
    
    // MARK: Setup
    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(downloadMenuItemDispatchedBy(notification:)), name: Notification.Name(rawValue: GYDwonloadMenuItemDispatchNotificationKey), object: nil)
    }
    func setupBuild() {
        let string = String(format: "%@ %@", GYCompileDate(), GYCompileTime())
        let date = string.date(format: "MMM dd yyyy HH:mm:ss", locale: "en_US")
        buildTimeMenuItem.title = String(format: "最近编译：%@", date!.string(format: "yyyy-MM-dd HH:mm:ss"))
    }
    func setupBase() {
        GYBase.shared.mainFolderPath = String(format: "%@/SynologyDrive/同步文档/App Data/Resource Studio", NSHomeDirectory())
        
        GYLogManager.shared.update(defaultColor: NSColor.labelColor, successColor: NSColor.systemGreen, warningColor: NSColor.systemYellow, errorColor: NSColor.systemRed, font: NSFont(name: "PingFangSC-Regular", size: 12.0)!)
    }
    func setupDownloads() {
        GYDownloadSettings.shared.updateMenuItems { [weak self] (menu: NSMenu) in
            self?.downloadRootMenuItem.submenu = menu
        }
    }
    
    // MARK: Actions
    @objc func downloadMenuItemDispatchedBy(notification: Notification) {
        if let menuItem = notification.object as? NSMenuItem {
            RSDispatchDownloadMenuItem(menuItem)
        }
    }
}

