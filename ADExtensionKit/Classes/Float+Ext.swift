//
//  Float+Ext.swift
//  ADExtensionKit
//
//  Created by xu on 2021/10/29.
//

import Foundation

extension Float: ExtensionCompatibleValue {}

public extension ExtensionWrapper where Base == Float {
   
    var int: Int { return Int(base) }

    var lroundInt: Int { return lroundf(base) }
    
    var cgFloat: CGFloat { return CGFloat(base) }
    
    var double: Double { return Double(base) }
    
    var string: String { return String(base) }
    
    var number: NSNumber { return NSNumber(value: base) }
    
}

public extension ExtensionWrapper where Base == Float {

    func trim(decimal: Int) -> Float {
        let divisor = pow(10.0, Float(decimal))
        return (base * divisor).rounded() / divisor
    }
    
}
