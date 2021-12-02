//
//  Date+Ext.swift
//  ADExtensionKit
//
//  Created by xu on 2021/11/3.
//

import Foundation

extension Date: ExtensionCompatibleValue {}

public extension ExtensionWrapper where Base == Date {
    
    static var timeStamp: TimeInterval {
        return Date().timeIntervalSince1970
    }
    
    static var now: Date {
        return Date()
    }
    
    var year: Int {
        return Calendar.current.component(.year, from: base)
    }
    
    var month: Int {
        return Calendar.current.component(.month, from: base)
    }
    
    var day: Int {
        return Calendar.current.component(.day, from: base)
    }
    
    var hour: Int {
        return Calendar.current.component(.hour, from: base)
    }
    
    var minute: Int {
        return Calendar.current.component(.minute, from: base)
    }
    
    var second: Int {
        return Calendar.current.component(.second, from: base)
    }
    
    var weekday: Int {
        return Calendar.current.component(.weekday, from: base)
    }
    
    var weekdayOrdinal: Int {
        return Calendar.current.component(.weekdayOrdinal, from: base)
    }
    
    func weekdayString(_ locale: Locale? = nil) -> String {
        let format = DateFormatter()
        format.locale = locale ?? Locale.current
        format.dateFormat = "EEEE"
        return format.string(from: base)
    }
    
    func monthString(_ locale: Locale? = nil) -> String {
        let format = DateFormatter()
        format.locale = locale ?? Locale.current
        format.dateFormat = "MMMM"
        return format.string(from: base)
    }
    
}

public extension ExtensionWrapper where Base == Date {
    
    static var yesterDay: Date? {
        return Calendar.current.date(byAdding: DateComponents(day: -1), to: Date())
    }
    
    static var tomorrow: Date? {
        return Calendar.current.date(byAdding: DateComponents(day: 1), to: Date())
    }
    
    var isToday: Bool {
        return Calendar.current.isDate(base, inSameDayAs: Date())
    }
    
    var isYesterday: Bool {
        guard let date = Date.ext.yesterDay else {
            return false
        }
        return date.ext.isToday
    }
    
    var isThisWeek: Bool {
        let calendar = Calendar.current
        let nowComponents = calendar.dateComponents([.weekday, .month, .year], from: Date())
        let selfComponents = calendar.dateComponents([.weekday,.month,.year], from: base)
        return (selfComponents.year == nowComponents.year) && (selfComponents.month == nowComponents.month) && (selfComponents.weekday == nowComponents.weekday)
    }
    
    var isThisYear: Bool  {
        let calendar = Calendar.current
        let nowCmps = calendar.dateComponents([.year], from: Date())
        let selfCmps = calendar.dateComponents([.year], from: base)
        return nowCmps.year == selfCmps.year
    }
    
    var isLeapYear: Bool {
        let year = base.ext.year
        return ((year % 400 == 0) || ((year % 100 != 0) && (year % 4 == 0)))
    }
    
    func isSameDay(with: Date) -> Bool {
        return Calendar.current.isDate(base, inSameDayAs: with)
    }
    
    func adding(day: Int) -> Date? {
        return Calendar.current.date(byAdding: DateComponents(day: day), to: base)
    }
    
}

public extension ExtensionWrapper where Base == Date {
    
    func componentCompare(from date: Date, unit: Set<Calendar.Component> = [.year,.month,.day]) -> DateComponents {
        return Calendar.current.dateComponents(unit, from: date, to: base)
    }
    
    func days(from date: Date) -> Int? {
       return componentCompare(from: date, unit: [.day]).day
    }
    
    func hours(from date: Date) -> Int? {
       return componentCompare(from: date, unit: [.hour]).hour
    }
    
    func minutes(from date: Date) -> Int? {
       return componentCompare(from: date, unit: [.minute]).minute
    }
    
    func seconds(from date: Date) -> Int? {
       return componentCompare(from: date, unit: [.second]).second
    }
    
}
