//
//  Array+Ext.swift
//  ADExtensionKit
//
//  Created by xu on 2021/10/29.
//

import Foundation

extension Array: ExtensionCompatibleValue {}

public extension ExtensionWrapper where Base: Collection {
    
    func element(at index: Int) -> Base.Element? {
        return index < base.count ? base[base.index(base.startIndex, offsetBy: index)] : nil
    }
    
    subscript(index: Int) -> Base.Element? {
        return index < base.count ? base[base.index(base.startIndex, offsetBy: index)] : nil
    }
    
}

public extension ExtensionWrapper where Base: RangeReplaceableCollection, Base.Element: Equatable {
    
    mutating func delete(element: Base.Element, repeated: Bool = false) -> Base {
        var indexs: [Int] = []
        for (idx,value) in base.enumerated() {
            if value == element {
                indexs.append(idx)
                if !repeated { break }
            }
        }
        for index in indexs.reversed() {
            base.remove(at: base.index(base.startIndex, offsetBy: index))
        }
        return base
    }
    
}
