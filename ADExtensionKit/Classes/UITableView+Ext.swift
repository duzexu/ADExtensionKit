//
//  UITableView+Ext.swift
//  ADExtensionKit
//
//  Created by xu on 2021/11/30.
//

import Foundation

public extension ExtensionWrapper where Base: UITableView {
    
    func neverAdjustContentInset() {
        if #available(iOS 11, *) {
            base.estimatedRowHeight = 0
            base.estimatedSectionFooterHeight = 0
            base.estimatedSectionHeaderHeight = 0
            base.contentInsetAdjustmentBehavior = .never
        }
    }
    
    func regisiter(cell: AnyClass) {
        base.register(cell, forCellReuseIdentifier: NSStringFromClass(cell))
    }
    
    func regisiter(nib: AnyClass) {
        base.register(UINib(nibName: NSStringFromClass(nib).components(separatedBy: ".").last!, bundle: nil), forCellReuseIdentifier: NSStringFromClass(nib))
    }
    
    func regisiterHeaderFooter(view: AnyClass) {
        base.register(view, forHeaderFooterViewReuseIdentifier: NSStringFromClass(view))
    }
    
    func regisiterHeaderFooter(nib: AnyClass) {
        base.register(UINib(nibName: NSStringFromClass(nib).components(separatedBy: ".").last!, bundle: nil), forHeaderFooterViewReuseIdentifier: NSStringFromClass(nib))
    }
    
    func dequeueReusableCell<T: UITableViewCell>(type: T.Type, cellForRowAt indexPath: IndexPath) -> T {
        return base.dequeueReusableCell(withIdentifier: NSStringFromClass(type), for: indexPath) as! T
    }
    
}

public extension ExtensionWrapper where Base: UITableViewCell {
    
    static var reuseIdentifier: String {
        return NSStringFromClass(Base.self)
    }
    
}

public extension ExtensionWrapper where Base: UITableViewHeaderFooterView {
    
    static var reuseIdentifier: String {
        return NSStringFromClass(Base.self)
    }
    
}
