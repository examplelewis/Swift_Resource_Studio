//
//  Array+GYSubscript.swift
//  Resource Studio
//
//  Created by 龚宇 on 22/05/16.
//

import Foundation

extension Array {
    subscript(index1: Int, index2: Int, indexRest: Int...) -> [Element] {
        // 实现 get 方法，获取数组中对应的值
        get {
            var result: [Element] = [self[index1], self[index2]]
            
            // indexRest 则是可变参数中剩余参数组成的数组
            for index in indexRest {
                result.append(self[index])
            }
            
            return result
        }
        
        // 实现 set 方法，对数组对应的索引赋值
        set(values) {
            // indexes 是所有 参数组成的数组
            let indexes = [index1, index2] + indexRest
            // zip 函数，将两个数组组成二元数组，可以理解成元组的数组，每个元组里面都是 index 和 value 一一对应
            let tuple = zip(indexes, values)
            
            for (index, value) in tuple {
                self[index] = value
            }
        }
    }
}
