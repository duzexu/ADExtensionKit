//
//  Int+Ext.swift
//  ADExtensionKit
//
//  Created by xu on 2021/10/29.
//

import Foundation

extension Int: ExtensionCompatibleValue {}

public extension ExtensionWrapper where Base == Int {
   
    var double: Double { return Double(base) }

    var float: Float { return Float(base) }
    
    var cgFloat: CGFloat { return CGFloat(base) }
    
    var string: String { return String(base) }
    
    var number: NSNumber { return NSNumber(value: base) }
    
}
