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
        setupBuild()
        
        RSAppManager.shared.setup()
        RSUIManager.shared.appDelegate = self
        
        GYDownloadSettings.shared.updateMenuItems()
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
        GYDispatchMenuItem(sender)
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
    func setupBuild() {
        let string = String(format: "%@ %@", RSCompileDate(), RSCompileTime())
        let date = string.dateWith(format: "MMM dd yyyy HH:mm:ss", locale: "en_US")
        buildTimeMenuItem.title = String(format: "最近编译：%@", date!.stringWith(format: "yyyy-MM-dd HH:mm:ss"))
    }
}

