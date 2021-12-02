//
//  String+Ext.swift
//  ADExtensionKit
//
//  Created by xu on 2021/11/1.
//

import Foundation

public enum StringType {
    /// 数字
    case number
    /// 字母
    case letter
    /// 汉字
    case Chinese
    /// 表情
    case emoji
}

extension String: ExtensionCompatibleValue {}

public extension ExtensionWrapper where Base: StringProtocol {
    
    var int: Int? { return Int(base) }
   
    var double: Double? { return Double(base) }

    var float: Float? { return Float(base) }
        
}

public extension ExtensionWrapper where Base: StringProtocol {
   
    var length: Int { return base.count }
    
    func contains(string: String, options: String.CompareOptions = []) -> Bool {
        return base.range(of: string, options: options) != nil
    }
    
    /// 转成拼音
    /// - Parameter isTone: true：带声调，false：不带声调，默认 false
    /// - Returns: 拼音
    func toPinyin(_ isTone: Bool = false) -> String {
        let mutableString = NSMutableString(string: self.base as! String)
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
        if !isTone {
            CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false)
        }
        return String(mutableString)
    }
    
    func pinyinInitials(_ isUpper: Bool = true) -> String {
        let pinyin = toPinyin(false).components(separatedBy: " ")
        let initials = pinyin.compactMap { String(format: "%c", $0.cString(using:.utf8)![0]) }
        return isUpper ? initials.joined().uppercased() : initials.joined()
    }
    
    func copyToClipboard() {
        UIPasteboard.general.string = base as? String
    }
    
    func trim() -> String {
        return base.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func urlEncode() -> String? {
        var charSet = CharacterSet.urlQueryAllowed
        charSet.insert(charactersIn: "%")
        return base.addingPercentEncoding(withAllowedCharacters: charSet)
    }
    
    func urlDecode() -> String? {
        return base.removingPercentEncoding
    }
    
    func predicateValue(regex: String) -> Bool {
        let predicator: NSPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicator.evaluate(with: base)
    }
    
    func matchStringType(_ type: StringType) -> Bool {
        var regularStr = ""
        switch type {
        case .number:
            regularStr = "^[0-9]*$"
        case .letter:
            regularStr = "^[A-Za-z]+$"
        case .Chinese:
            regularStr = "[\\u4e00-\\u9fa5]"
        case .emoji:
            regularStr = "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"
        }
        
        return predicateValue(regex: regularStr)
    }
    
    func isSpecialLetter() -> Bool {
        let isNumber: Bool = matchStringType(.number)
        let isLeter: Bool = matchStringType(.letter)
        let isChinese: Bool = matchStringType(.Chinese)

        if isNumber || isLeter || isChinese {
            return false
        }
        return true
    }
    
}

public extension ExtensionWrapper where Base: StringProtocol {
    
    func isGreatOrEqual(version: String) -> Bool {
        var current = base.replacingOccurrences(of: ".", with: "")
        var other = version.replacingOccurrences(of: ".", with: "")
        let count = max(current.count, other.count)
        for _ in 0..<(count-current.count) {
            current += "0"
        }
        for _ in 0..<(count-other.count) {
            other += "0"
        }
        return Int(current)! >= Int(other)!
    }
    
    func isGreatThan(version: String) -> Bool {
        var current = base.replacingOccurrences(of: ".", with: "")
        var other = version.replacingOccurrences(of: ".", with: "")
        let count = max(current.count, other.count)
        for _ in 0..<(count-current.count) {
            current += "0"
        }
        for _ in 0..<(count-other.count) {
            other += "0"
        }
        return Int(current)! > Int(other)!
    }
    
}

public extension ExtensionWrapper where Base == String {
    
    var hexColor: UIColor? { return UIColor(hexString: base) }

}
