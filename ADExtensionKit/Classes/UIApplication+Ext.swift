//
//  UIApplication+Ext.swift
//  ADExtensionKit
//
//  Created by xu on 2021/11/30.
//

import Foundation
#if canImport(CoreLocation)
import CoreLocation
#endif

public enum ADNotificationTrigger {
    case interval(Double)
    case date(DateComponents)
    case region(CLCircularRegion)
}

public extension ExtensionWrapper where Base: UIApplication {
    
    static func registerAPNsWithDelegate(_ delegate: Any) {
        if #available(iOS 10.0, *) {
            let options: UNAuthorizationOptions = [.alert, .badge, .sound]
            let center = UNUserNotificationCenter.current()
            center.delegate = (delegate as! UNUserNotificationCenterDelegate)
            center.requestAuthorization(options: options) { _, _ in
            }
            UIApplication.shared.registerForRemoteNotifications()
        } else {
            let types: UIUserNotificationType = [.alert, .badge, .sound]
            let settings = UIUserNotificationSettings(types: types, categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    @available(iOS 10.0, *)
    func addLocalUserNoti(trigger: ADNotificationTrigger,
                          content: UNMutableNotificationContent,
                       identifier: String,
                          repeats: Bool = true) {
        var notiTrigger: UNNotificationTrigger?
        switch trigger {
        case let .interval(interval):
            notiTrigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: repeats)
        case let .date(components):
            notiTrigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: repeats)
        case let .region(region):
            notiTrigger = UNLocationNotificationTrigger(region: region, repeats: repeats)
        }
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: notiTrigger)
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
        }
    }
    
}
