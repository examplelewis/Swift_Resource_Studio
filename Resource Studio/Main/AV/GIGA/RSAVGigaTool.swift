//
//  RSAVGigaTool.swift
//  Resource Studio
//
//  Created by 龚宇 on 22/05/14.
//

import Foundation

func RSAVGigaWorkImageNameFrom(url: String, oldFileName: String) -> String {
    let urlComponets = url.components(separatedBy: "/")
    let series = urlComponets[urlComponets.count - 3]
    let newSeries = series.uppercased().appending("-")
    let workID = urlComponets[urlComponets.count - 2]
    var newName = workID.replacingOccurrences(of: series, with: newSeries)
    newName = newName.appendingFormat(".%@", (oldFileName as NSString).pathExtension)
    
    return newName
}
