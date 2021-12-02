//
//  Bundle+Ext.swift
//  ADExtensionKit
//
//  Created by xu on 2021/10/29.
//

import Foundation

extension Bundle: ExtensionCompatible {}

public extension ExtensionWrapper where Base: Bundle {
    
    static var appBundleName: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String
    }
    
    static var appDisplayName: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? appBundleName
    }
    
    static var appBundleID: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as! String
    }
    
    static var appVersion: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
    }
    
    static var appBuildVersion: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "1.0"
    }
    
}
