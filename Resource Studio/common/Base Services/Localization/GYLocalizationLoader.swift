//
//  GYLocalizationLoader.swift
//  Resource Studio
//
//  Created by 龚宇 on 22/05/17.
//

import Foundation

class GYLocalizationLoader {
    static var language: String? { Locale.preferredLanguages.first?.lowercased() }
    static var isZH: Bool { language != nil && language!.hasPrefix("zh") } // 是否是中文
    static var isZH_HANS: Bool { isZH && language!.contains("hans") } // 是否是简体中文
    static var isEN: Bool { language != nil && language!.hasPrefix("en") } // 是否是英文
    
    static var resBundle: Bundle?
    static var langCode: String?
    static var lprojBundle: Bundle?
    
    class func localizedStringForKey(_ key: String) -> String {
        if resBundle == nil || langCode == nil || lprojBundle == nil {
            if let resPath = Bundle.main.path(forResource: "GYLocalizationResource", ofType: "bundle") {
                resBundle = Bundle(path: resPath)
            }
            
            if isZH_HANS {
                langCode = "zh-hans"
            } else if isEN {
                langCode = "en"
            }
            
            if let lprojPath = resBundle?.path(forResource: langCode, ofType: "lproj") {
                lprojBundle = Bundle(path: lprojPath)
            }
        }
        
        let string = lprojBundle?.localizedString(forKey: key, value: nil, table: nil)
        return string != nil ? string! : ""
    }
    
}
