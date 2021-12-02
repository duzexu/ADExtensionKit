//
//  Double+Ext.swift
//  ADExtensionKit
//
//  Created by xu on 2021/10/29.
//

import Foundation

extension Double: ExtensionCompatibleValue {}

public extension ExtensionWrapper where Base == Double {
   
    var int: Int { return Int(base) }

    var lroundInt: Int { return lround(base) }
    
    var cgFloat: CGFloat { return CGFloat(base) }

    var float: Float { return Float(base) }
    
    var string: String { return String(base) }
    
    var number: NSNumber { return NSNumber(value: base) }
    
}

public extension ExtensionWrapper where Base == Double {
    
    func trim(decimal: Int) -> Double {
        let divisor = pow(10.0, Double(decimal))
        return (base * divisor).rounded() / divisor
    }
    
}
