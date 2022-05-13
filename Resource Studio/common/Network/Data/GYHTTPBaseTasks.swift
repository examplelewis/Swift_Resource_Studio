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
        if request.isHtml() {
            GYAlamofire.shared.sendHTMLTask(dataTask)
        } else {
            GYAlamofire.shared.sendTask(dataTask)
        }
    }
    
    // MARK: Cancel
    func cancelAll() {
        guard dataTasks.count > 0 else {
            return
        }
        
        _cancelTasks(dataTasks)
        GYSynchronized(self) {
            dataTasks.removeAll()
        }
    }
    func cancelTasksByReqName(_ name: String) {
        guard dataTasks.count > 0 else {
            return
        }
        
        let tasks = dataTasks.filter({ String(describing: $0.request) == name })
        _cancelTasks(tasks)
        GYSynchronized(self) {
            dataTasks.removeAll(where: { tasks.contains($0) })
        }
    }
    func _cancelTasks(_ tasks: [GYHTTPDataTask]) {
        for task in tasks {
            task.cancel()
            task.cancelBlock?(task.request)
        }
    }
    
    // MARK: GYHTTPDataDaskDelegate
    func dataTaskDidFinished(_ dataTask: GYHTTPDataTask) {
        if let rspError = dataTask.rspError {
            dataTask.failureBlock?(dataTask.request, rspError)
        } else if let response = dataTask.response {
            dataTask.successBlock?(dataTask.request, response)
        }
        
        GYSynchronized(self) {
            if let index = dataTasks.firstIndex(of: dataTask) {
                dataTasks.remove(at: index)
            }
        }
    }
}
