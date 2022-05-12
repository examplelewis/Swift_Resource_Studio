//
//  GYHTTPBaseTasks.swift
//  GYSwiftLib
//
//  Created by 龚宇 on 22/04/25.
//

import Foundation

class GYHTTPBaseTasks: GYHTTPDataDaskDelegate {
    private var dataTasks: [GYHTTPDataTask] = []
    
    // MARK: Initial
    deinit {
        cancelAll()
    }
    
    // MARK: Send
    func send(_ request: GYHTTPReqPackProtocol, success: GYHTTPSuccessBlock? = nil, failure: GYHTTPFailureBlock? = nil, cancel: GYHTTPCancelBlock? = nil) {
        let dataTask = GYHTTPDataTask(request: request, success: success, failure: failure, cancel: cancel)
        dataTask.delegate = self
        
        dataTasks.append(dataTask)
//        GYAlamofire.shared.send(dataTask)
    }
    
    // MARK: Cancel
    func cancelAll() {
        guard dataTasks.count > 0 else {
            return
        }
        
        _cancelTasks(dataTasks)
//        GYLock {
            dataTasks.removeAll()
//        }
    }
    func cancelTasksByReqName(_ name: String) {
        guard dataTasks.count > 0 else {
            return
        }
        
        let tasks = dataTasks.filter({ String(describing: $0.request) == name })
        _cancelTasks(tasks)
//        GYLock {
            
//        }
    }
    func _cancelTasks(_ tasks: [GYHTTPDataTask]) {
        
    }
    
    // MARK: GYHTTPDataDaskDelegate
    func dataTaskDidFinished(_ dataTask: GYHTTPDataTask) {
        
    }
}
