//
//  UserDefaults+Ext.swift
//  ADExtensionKit
//
//  Created by xu on 2021/11/23.
//

import Foundation

extension UserDefaults: ExtensionCompatible {}

public extension ExtensionWrapper where Base: UserDefaults {
    
    static func setObject<T: Decodable & Encodable>(_ object: T, forKey key: String) {
        let encoder = JSONEncoder()
        guard let encoded = try? encoder.encode(object) else {
            return
        }
        Base.standard.set(encoded, forKey: key)
        Base.standard.synchronize()
    }
    
    static func getObject<T: Decodable & Encodable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = Base.standard.data(forKey: key) else {
            return nil
        }
        let decoder = JSONDecoder()
        guard let object = try? decoder.decode(type, from: data) else {
            return nil
        }
        return object
    }
    
}
