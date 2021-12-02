//
//  FileManager+Ext.swift
//  ADExtensionKit
//
//  Created by xu on 2021/11/3.
//

import Foundation

extension FileManager: ExtensionCompatible {}

public extension ExtensionWrapper where Base: FileManager {
    
    static var fileManager: FileManager {
        return FileManager.default
    }
    
    static var documentDir: String { fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!.path }
    
    static var libraryDir: String { fileManager.urls(for: .libraryDirectory, in: .userDomainMask).first!.path }
    
    static var cachesDir: String { fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!.path }
    
    static var tmpDir: String { NSTemporaryDirectory() }
    
}

public extension ExtensionWrapper where Base: FileManager {
    
    static func directory(atPath path: String) -> String {
        return (path as NSString).deletingLastPathComponent
    }
    
    static func fileSuffix(atPath path: String) -> String {
        return (path as NSString).pathExtension
    }
    
    static func fileName(atPath path: String, suffix: Bool = true) -> String {
        let fileName = (path as NSString).lastPathComponent
        guard suffix else {
            return (fileName as NSString).deletingPathExtension
        }
        return fileName
    }
    
    static func createDirectory(atPath path: String, attr: [FileAttributeKey : Any]? = nil) throws {
        if !fileManager.fileExists(atPath: path) {
            try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: attr)
        }
    }
    
    static func removeDirectory(atPath path: String) throws {
        if fileManager.fileExists(atPath: path) {
            try fileManager.removeItem(atPath: path)
        }
    }
    
    static func moveItem(atPath srcPath: String, toPath dstPath: String, overwrite: Bool = true) throws {
        let directory = directory(atPath: dstPath)
        try createDirectory(atPath: directory)
        if overwrite {
            try removeItem(atPath: dstPath)
        }
        try fileManager.moveItem(atPath: srcPath, toPath: dstPath)
    }
    
    static func removeItem(atPath path: String) throws {
        if fileManager.fileExists(atPath: path) {
            try fileManager.removeItem(atPath: path)
        }
    }
    
    static func copyItem(atPath srcPath: String, toPath dstPath: String, overwrite: Bool = true) throws {
        let directory = directory(atPath: dstPath)
        try createDirectory(atPath: directory)
        if overwrite {
            try removeItem(atPath: dstPath)
        }
        try fileManager.copyItem(atPath: srcPath, toPath: dstPath)
    }
    
    static func fileExists(atPath path: String, isDirectory: UnsafeMutablePointer<ObjCBool>?) -> Bool {
        return fileManager.fileExists(atPath: path, isDirectory: isDirectory)
    }
    
    static func contentsOfDirectory(atPath path: String) throws -> [String] {
        return try fileManager.contentsOfDirectory(atPath: path)
    }
    
    static func subpaths(atPath path: String) -> [String]? {
        return fileManager.subpaths(atPath: path)
    }
    
}

public extension ExtensionWrapper where Base: FileManager {
    
    static func allFiles(atPath path: String, recursion: Bool = false) -> [String] {
        if !fileManager.fileExists(atPath: path) {
            return []
        }
        if recursion {
            return (fileManager.enumerator(atPath: path)?.allObjects as? [String]) ?? []
        }else{
            return (try? fileManager.contentsOfDirectory(atPath: path)) ?? []
        }
    }
    
    static func size(atPath path: String) -> UInt64 {
        if !fileManager.fileExists(atPath: path) {
            return 0
        }
        guard let arrti = try? fileManager.attributesOfItem(atPath: path), let size = arrti[FileAttributeKey.size] as? UInt64 else {
            return 0
        }
        return size
    }
    
    static func fileIsEqual(path1: String, path2: String) -> Bool {
        guard !fileManager.fileExists(atPath: path1), !fileManager.fileExists(atPath: path2) else {
            return false
        }
        return fileManager.contentsEqual(atPath: path1, andPath: path2)
    }
    
}

public extension ExtensionWrapper where Base: FileManager {
    
    static func save(content: Data?, to path: String, attributes attr: [FileAttributeKey : Any]? = nil) throws {
        let directory = directory(atPath: path)
        try createDirectory(atPath: directory, attr: attr)
        fileManager.createFile(atPath: path, contents: content, attributes: attr)
    }
    
}
