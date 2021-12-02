//
//  Dictionary+Ext.swift
//  ADExtensionKit
//
//  Created by xu on 2021/11/3.
//

import Foundation

public extension ExtensionWrapper where Base: Encodable {
    
    func toJSON() -> String? {
        if let data = try? JSONEncoder().encode(base) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    func save(to path: String) {
        do {
            let data = try JSONEncoder().encode(base)
            try FileManager.ext.save(content: data, to: path, attributes: nil)
        }
        catch {
            print("save error \(error)")
        }
    }
    
}

public extension ExtensionWrapper where Base: Decodable {
    
    static func load<T>(from path: String) -> T? where T : Decodable {
        let url = URL(fileURLWithPath: path, isDirectory: false)
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            return nil
        }
    }
    
}
