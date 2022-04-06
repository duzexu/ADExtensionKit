//
//  UICollectionView+Ext.swift
//  ADExtensionKit
//
//  Created by xu on 2021/12/1.
//

import UIKit

public extension ExtensionWrapper where Base: UICollectionView {
    
    func regisiter(cell: AnyClass) {
        base.register(cell, forCellWithReuseIdentifier: NSStringFromClass(cell))
    }
    
    func regisiter(nib: AnyClass) {
        base.register(UINib(nibName: NSStringFromClass(nib).components(separatedBy: ".").last!, bundle: nil), forCellWithReuseIdentifier: NSStringFromClass(nib))
    }
    
    func regisiterHeader(view: AnyClass) {
        base.register(view, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NSStringFromClass(view))
    }
    
    func regisiterFooter(view: AnyClass) {
        base.register(view, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: NSStringFromClass(view))
    }
    
    func regisiterHeader(nib: AnyClass) {
        base.register(UINib(nibName: NSStringFromClass(nib).components(separatedBy: ".").last!, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NSStringFromClass(nib))
    }
    
    func regisiterFooter(nib: AnyClass) {
        base.register(UINib(nibName: NSStringFromClass(nib).components(separatedBy: ".").last!, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: NSStringFromClass(nib))
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(type: T.Type, cellForRowAt indexPath: IndexPath) -> T {
        return base.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(type), for: indexPath) as! T
    }
    
    func dequeueReusableHeaderView<T: UICollectionReusableView>(type: T.Type, viewForRowAt indexPath: IndexPath) -> T {
        return base.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NSStringFromClass(type), for: indexPath) as! T
    }
    
    func dequeueReusableFooterView<T: UICollectionReusableView>(type: T.Type, viewForRowAt indexPath: IndexPath) -> T {
        return base.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: NSStringFromClass(type), for: indexPath) as! T
    }
    
}

public extension ExtensionWrapper where Base: UICollectionViewCell {
    
    static var reuseIdentifier: String {
        return NSStringFromClass(Base.self)
    }
    
}

public extension ExtensionWrapper where Base: UICollectionReusableView {
    
    static var reuseIdentifier: String {
        return NSStringFromClass(Base.self)
    }
    
}
