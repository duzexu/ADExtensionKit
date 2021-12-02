//
//  UILabel+Ext.swift
//  ADExtensionKit
//
//  Created by xu on 2021/11/29.
//

import Foundation

public extension ExtensionWrapper where Base: UILabel {
    
    func modifySpace(lineSpace:CGFloat = 0, wordSpace: CGFloat = 0, paragraphSpace: CGFloat = 0 ,alignment: NSTextAlignment = .left) {
        let labelText = base.text
        if labelText != nil {
            let attribute = NSMutableAttributedString(string: labelText!)

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.paragraphSpacing = paragraphSpace
            paragraphStyle.lineSpacing = lineSpace
            paragraphStyle.alignment = alignment
            attribute.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: labelText!.count))
            if wordSpace > 0 {
                attribute.addAttribute(NSAttributedString.Key.kern, value: Float( wordSpace), range: NSRange(location: 0, length: labelText!.count))
            }
            if let f = base.font {
                attribute.addAttribute(NSAttributedString.Key.font, value: f, range: NSRange(location: 0, length: labelText!.count))
            }
            attribute.addAttribute(NSAttributedString.Key.baselineOffset, value: 0, range: NSRange(location: 0, length: labelText!.count))
            attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: base.textColor!, range: NSRange(location: 0, length: labelText!.count))
            base.attributedText = attribute
        }
    }
    
}
