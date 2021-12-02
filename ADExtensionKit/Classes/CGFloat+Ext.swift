//
//  CGFloat+Ext.swift
//  ADExtensionKit
//
//  Created by xu on 2021/10/29.
//

import Foundation

extension CGFloat: ExtensionCompatibleValue {}

public extension ExtensionWrapper where Base == CGFloat {
   
    var int: Int { return Int(base) }
    
    var float: Float { return Float(base) }
    
    var double: Double { return Double(base) }
    
    var string: String { return String(Double(base)) }
    
    var number: NSNumber { return NSNumber(value: base) }
    
}

public extension ExtensionWrapper where Base == CGFloat {

    func trim(decimal: Int) -> CGFloat {
        let divisor = pow(10.0, CGFloat(decimal))
        return (base * divisor).rounded() / divisor
    }
    
    /// Returns the closest number that can be divided evenly.
    /// - Parameter by: Dividend number.
    /// - Returns: Closest number that can be divided evenly.
    func truncating(by: Int) -> Int {
        let divid = (base - base.truncatingRemainder(dividingBy: CGFloat(by)))/CGFloat(by)
        let ret1 = divid*CGFloat(by)
        let ret2 = (divid+1)*CGFloat(by)
        return abs(ret1-base) < abs(ret2-base) ? Int(ret1) : Int(ret2)
    }
    
    func degreeToRadian() -> CGFloat {
        return (.pi * base) / 180.0
    }
    
    func radianToDegree() -> CGFloat {
        return (base * 180.0) / .pi
    }
    
}
