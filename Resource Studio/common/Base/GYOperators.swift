//
//  GYOperators.swift
//  Resource Studio
//
//  Created by 龚宇 on 22/05/11.
//

import Foundation
#if os(iOS)
    import UIKit
#endif

infix operator <>: ComparisonPrecedence

func <> (left: Int, right: Range<Double>) -> Bool { left >= Int(right.lowerBound) && left < Int(right.upperBound) }
func <> (left: UInt, right: Range<Double>) -> Bool { left >= UInt(right.lowerBound) && left < UInt(right.upperBound) }
func <> (left: Float, right: Range<Double>) -> Bool { left >= Float(right.lowerBound) && left < Float(right.upperBound) }
func <> (left: CGFloat, right: Range<Double>) -> Bool { left >= CGFloat(right.lowerBound) && left < CGFloat(right.upperBound) }
func <> (left: Double, right: Range<Double>) -> Bool { left >= right.lowerBound && left < right.upperBound }

func <> (left: Int, right: ClosedRange<Double>) -> Bool { left >= Int(right.lowerBound) && left <= Int(right.upperBound) }
func <> (left: UInt, right: ClosedRange<Double>) -> Bool { left >= UInt(right.lowerBound) && left <= UInt(right.upperBound) }
func <> (left: Float, right: ClosedRange<Double>) -> Bool { left >= Float(right.lowerBound) && left <= Float(right.upperBound) }
func <> (left: CGFloat, right: ClosedRange<Double>) -> Bool { left >= CGFloat(right.lowerBound) && left <= CGFloat(right.upperBound) }
func <> (left: Double, right: ClosedRange<Double>) -> Bool { left >= right.lowerBound && left <= right.upperBound }


// 重载 加法 运算符: point + size = rect
func + (lhs: CGPoint, rhs: CGSize) -> CGRect { CGRect(x: lhs.x, y: lhs.y, width: rhs.width, height: rhs.height) }
