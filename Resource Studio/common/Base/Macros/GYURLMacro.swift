//
//  GYURLMacro.swift
//  Resource Studio
//
//  Created by 龚宇 on 22/05/20.
//

import Foundation

// MARK: Parameter
func GYParametersFrom(data: Data?) -> [String: String]? {
    if let string = GYStringFrom(data: data) {
        return GYParametersFrom(string: string)
    } else {
        return nil
    }
}
func GYParametersFrom(string: String) -> [String: String]? {
    var dictionary: [String: String]?
    let parameters = string.components(separatedBy: "&")
    for parameter in parameters {
        let components = parameter.components(separatedBy: "=")
        if components.count == 2 {
            if dictionary == nil {
                dictionary = [:]
            }
            
            dictionary![components.first!] = components.last!
        }
    }
    
    return dictionary
}
