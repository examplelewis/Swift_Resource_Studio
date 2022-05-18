//
//  NSError+GYExtension.swift
//  GYSwiftLib
//
//  Created by 龚宇 on 22/04/23.
//

import Foundation

extension NSError {
    var downloadUrl: String {
        var url: String? = userInfo[NSURLErrorFailingURLStringErrorKey] as? String
        if url != nil, !url!.isEmpty {
            return url!
        }
        
        url = userInfo["NSErrorFailingURLKey"] as? String
        if url != nil, !url!.isEmpty {
            return url!
        }
        
        url = userInfo["NSErrorFailingURLStringKey"] as? String
        if url != nil, !url!.isEmpty {
            return url!
        }
        
        return ""
    }
    var downloadErrorType: GYErrorType {
        print("error code: \(self.code)")
        if localizedDescription.contains("") || localizedDescription.contains("") {
            return .download(.connectionLost)
        } else {
            return .undefined
        }
    }
}
