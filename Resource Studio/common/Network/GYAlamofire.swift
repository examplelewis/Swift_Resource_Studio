//
//  GYAlamofire.swift
//  GYSwiftLib
//
//  Created by 龚宇 on 22/04/23.
//

import Foundation
import Alamofire
import hpple
import DateTools

fileprivate func cookieProperty(from model: GYHTTPCookie) -> [HTTPCookiePropertyKey: Any] {
    return [.name: model.name!, .path: model.path!, .value: model.value!, .secure: model.secure!, .domain: model.domain!, .originURL: model.domain!]
}
fileprivate func updateCookies(_ configuration: URLSessionConfiguration) {
    guard GYFileManager.itemExists(atPath: GYBase.shared.cookieFolderPath) else {
        return
    }
    let cookieFiles = GYFileManager.filePaths(inFolder: GYBase.shared.cookieFolderPath)
    guard cookieFiles.count > 0 else {
        return
    }
    
    configuration.httpCookieStorage?.cookieAcceptPolicy = .always
    for cookieFile in cookieFiles {
        if let string = try? String(contentsOfFile: cookieFile) {
            let cookies = [GYHTTPCookie].deserialize(from: string)!
            for cookie in cookies {
                let httpCookie = HTTPCookie(properties: cookieProperty(from: cookie!))
                if let expiresDate = httpCookie?.expiresDate, (expiresDate as NSDate).isEarlierThan(Date.current()) {
                    let fileName = ((cookieFile as NSString).lastPathComponent as NSString).deletingPathExtension
                    let cookieName = httpCookie!.name
                    
                    GYLogManager.shared.addWarningLog(format: "%@ 的 %@ 已过期，需要使用 Chrome 再次获取 Cookie", fileName, cookieName)
                }
                
                configuration.httpCookieStorage?.setCookie(httpCookie!)
            }
        }
    }
}

class GYAlamofire {
    static let shared = GYAlamofire()
    
    let session: Session
    
    init() {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 15
        configuration.timeoutIntervalForResource = 15
        configuration.allowsCellularAccess = true
        configuration.waitsForConnectivity = true
        configuration.headers = HTTPHeaders([:])
        updateCookies(configuration)
        
        let interceptor = Interceptor(adapter: GYHTTPRequestAdapter(), retrier: GYHTTPRequestRetrier())
        session = Session(configuration: configuration, interceptor: interceptor, serverTrustManager: GYHTTPServerTrustManager(evaluators: [:]), eventMonitors: [GYHTTPEventMonitor()])
    }
    
    func sendHTMLTask(_ task: GYHTTPDataTask) {
        let request = task.request
        let dataRequest = GYHTTPDataRequest(url: request.url(), method: request.method(), headers: request.headers(), parameters: request.pack())
        
        session.request(dataRequest).responseData { (dataResponse: AFDataResponse<Data>) in
            GYHTTPPrinter.printAFDataResponse(dataResponse)

            if dataResponse.error != nil {
                task.rspError = dataResponse.error
            } else if let urlRequest = dataResponse.request, let _ = urlRequest.url, let urlResponse = dataResponse.response {
                task.rspHeader = urlResponse.allHeaderFields as? [String: Any]

                if let dataValue = dataResponse.value, let baseResponse = request.rspType().init() as? GYHTTPBaseHTMLResponse {
                    print("data3: \(dataValue.count)")
                    baseResponse.parser = TFHpple(htmlData: dataValue)
                    baseResponse.headers = task.rspHeader

                    task.response = baseResponse
                } else {
                    // 如果baseResponse为nil，那么说明服务器反回的JSON字符串解析错误
                    task.rspError = URLError(.cannotDecodeContentData)
                }
            } else {
                task.rspError = URLError(.cannotParseResponse)
            }

            if !task.invalid {
                task.delegate?.dataTaskDidFinished(task)
            }
        }
    }
    
    func sendTask(_ task: GYHTTPDataTask) {
        let request = task.request
        let dataRequest = GYHTTPDataRequest(url: request.url(), method: request.method(), headers: request.headers(), parameters: request.pack())
        
        session.request(dataRequest).responseData { (dataResponse: AFDataResponse<Data>) in
            GYHTTPPrinter.printAFDataResponse(dataResponse)
            
            if dataResponse.error != nil {
                task.rspError = dataResponse.error
            } else if let urlRequest = dataResponse.request, let _ = urlRequest.url, let urlResponse = dataResponse.response {
                task.rspHeader = urlResponse.allHeaderFields as? [String: Any]
                
                if let baseResponse = request.rspType().unpack(data: dataResponse.value) {
                    baseResponse.headers = task.rspHeader
                    
                    task.response = baseResponse
                } else {
                    // 如果baseResponse为nil，那么说明服务器反回的JSON字符串解析错误
                    task.rspError = URLError(.cannotDecodeContentData)
                }
            } else {
                task.rspError = URLError(.cannotParseResponse)
            }
            
            if !task.invalid {
                task.delegate?.dataTaskDidFinished(task)
            }
        }
    }
}
