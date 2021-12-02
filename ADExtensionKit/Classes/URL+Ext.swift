//
//  URL+Ext.swift
//  ADExtensionKit
//
//  Created by xu on 2021/11/23.
//

import Foundation

extension URL: ExtensionCompatibleValue {}

public extension ExtensionWrapper where Base == URL {
    
    var queryParameters: [String: String]? {
        guard let components = URLComponents(url: base, resolvingAgainstBaseURL: true), let queryItems = components.queryItems else {
            return nil
        }
        var parameters = [String: String]()
        for item in queryItems {
            parameters[item.name] = item.value
        }
        return parameters
    }
    
}
