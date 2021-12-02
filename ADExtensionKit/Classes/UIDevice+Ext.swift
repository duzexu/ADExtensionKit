//
//  UIDevice+Ext.swift
//  ADExtensionKit
//
//  Created by xu on 2021/11/3.
//

import Foundation
import CoreTelephony

private let rootURL = URL(fileURLWithPath: NSHomeDirectory())

extension UIDevice: ExtensionCompatible {}

public extension ExtensionWrapper where Base: UIDevice {
    
    static var systemVersion: String {
        return UIDevice.current.systemVersion
    }
    
    static var deviceName: String {
        return UIDevice.current.name
    }
    
    static var deviceLanguage: String {
        return Bundle.main.preferredLocalizations[0]
    }
        
    static var volumeTotalCapacity: Int? {
        return (try? rootURL.resourceValues(forKeys: [.volumeTotalCapacityKey]))?.volumeTotalCapacity
    }
    
    static var volumeAvailableCapacity: Int? {
        return (try? rootURL.resourceValues(forKeys: [.volumeAvailableCapacityKey]))?.volumeAvailableCapacity
    }
    
    static var physicalMemory: UInt64 {
        return ProcessInfo.processInfo.physicalMemory
    }
    
    static func carrierNames() -> [String]? {
        guard  let carriers = getCarriers(), carriers.count > 0 else {
            return nil
        }
        return carriers.map{ $0.carrierName! }
    }
    
    private static func getCarriers() -> [CTCarrier]? {
        let info = CTTelephonyNetworkInfo()
        if #available(iOS 12.0, *) {
            guard let providers = info.serviceSubscriberCellularProviders else {
                return nil
            }
            return Array(providers.filter { $0.value.carrierName != nil }.values)
        } else {
            guard let carrier = info.subscriberCellularProvider, carrier.carrierName != nil else {
                return nil
            }
            return [carrier]
        }
    }
    
}
