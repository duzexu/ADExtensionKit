//
//  UIView+Ext.swift
//  ADExtensionKit
//
//  Created by xu on 2021/10/28.
//

import Foundation

extension UIView: ExtensionCompatible {}

public extension ExtensionWrapper where Base: UIView  {
    static func loadFromNib(_ nibname: String? = nil) -> Base {
        let loadName = nibname == nil ? "\(self)" : nibname!
        return Bundle.main.loadNibNamed(loadName, owner: nil, options: nil)?.first as! Base
    }
}

public extension ExtensionWrapper where Base: UIView {
    
    var width: CGFloat {
        get { base.frame.size.width }
        set { base.frame.size.width = newValue }
    }
    
    var height: CGFloat {
        get { base.frame.size.height }
        set { base.frame.size.height = newValue }
    }
    
    var origin: CGPoint {
        get { base.frame.origin }
        set { base.frame.origin = newValue }
    }
    
    var size: CGSize {
        get { base.frame.size }
        set { base.frame.size = newValue }
    }
    
    var left: CGFloat {
        get { base.frame.origin.x }
        set { base.frame.origin.x = newValue }
    }
    
    var right: CGFloat {
        get { base.frame.origin.x+base.frame.size.width }
        set { base.frame.origin.x = newValue-base.frame.size.width }
    }
    
    var top: CGFloat {
        get { base.frame.origin.y }
        set { base.frame.origin.y = newValue }
    }
    
    var bottom: CGFloat {
        get { base.frame.origin.y+base.frame.size.height }
        set { base.frame.origin.y = newValue-base.frame.size.height }
    }
    
    var center: CGPoint {
        get { base.center }
        set { base.center = newValue }
    }
    
    var centerX: CGFloat {
        get { base.center.x }
        set { base.center.x = newValue }
    }
    
    var centerY: CGFloat {
        get { base.center.y }
        set { base.center.y = newValue }
    }
    
}

public extension ExtensionWrapper where Base: UIView {
    
    func renderAsImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(base.frame.size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        base.layer.render(in: context)
        let viewImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return viewImage
    }
    
    func removeAllSubViews() {
        for subView in base.subviews {
            subView.removeFromSuperview()
        }
    }
    
}
