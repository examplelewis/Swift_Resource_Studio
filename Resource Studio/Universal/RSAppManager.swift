//
//  RSAppManager.swift
//  Resource Studio
//
//  Created by 龚宇 on 22/05/13.
//

import Foundation
import AppKit

class RSAppManager {
    static let shared = RSAppManager()
    
    var emojis: [String] = []
    var mangaExceptions: [String] = []
    var fileSearchOneDrive = ""
    
    func setup() {
        _setupFromMainPref()
    }
    private func _setupFromMainPref() {
        let mainPrefFilePath = GYBase.shared.pathOfPreference("RSMainPref")
        guard let mainPref = try? NSDictionary(contentsOf: URL(fileURLWithPath: mainPrefFilePath), error: ()) else {
            return
        }
        
        if let emojis = mainPref.value(forKeyPath: "String.Emojis") as? [String] {
            self.emojis = emojis
        }
        if let mangaExceptions = mainPref.value(forKeyPath: "Manga.Exceptions") as? [String] {
            self.mangaExceptions = mangaExceptions
        }
        if let fileSearchOneDrive = mainPref.value(forKeyPath: "File.SearchCharacters.OneDrive") as? String {
            self.fileSearchOneDrive = fileSearchOneDrive
        }
    }
}
