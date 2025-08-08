//
//  Date+Extension.swift
//  CheckAttend
//
//  Created by 송은아 on 8/6/25.
//

import Foundation

extension Date {
    func nowTime(format: String = "yyyy년 M월 d일") -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = format
        
        return formatter.string(from: self)
    }
    
    /// Date 객체에서 시간 정보를 제거
    /// - Returns: 시간 정보가 제거된 Date 객체
    func removeTime() -> Date {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!
        let components = calendar.dateComponents([.year, .month, .day], from: self)
        return Calendar.current.date(from: components)!
    }
    
    /// Date 객체에서 시간 정보 반환
    /// - Returns: 해당 시간
    func getHour() -> Int {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!
        let hour = calendar.component(.hour, from: self)
        return hour
    }
    
    /// Date 객체에서 월 정보 반환
    /// - Returns: 해당 월
    func getMonth() -> Int {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!
        let month = calendar.component(.month, from: self)
        return month
    }
    
    /// Date 객체에서 날짜 정보 반환
    /// - Returns: 해당 요일
    func getDay() -> Int {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!
        let day = calendar.component(.day, from: self)
        return day
    }
    
    /// Date 객체에서 요일 정보 반환
    /// - Returns: 해당 요일
    func getWeekDay() -> Int {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!
        let day = calendar.component(.weekday, from: self)
        return day
    }
    
    /// 일요일 여부 반환
    /// - Returns: 일요일 여부
    func isSunday() -> Bool {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!
        let day = calendar.component(.weekday, from: self)
        return day == 1
    }
    
    /// Date 객체를 String 객체로 변환
    /// - Parameters:
    ///   - format: DateFormat 형식 (예: yyyy.MM.dd hh:mm:ss)
    ///   - am: 오전 표시 문자열
    ///   - pm: 오후 표시 문자열
    /// - Returns: 변환된 문자열 객체
    func toString(_ format: String, am: String? = nil, pm: String? = nil) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        dateFormatter.dateFormat = format
        
        if let amSymbol = am {
            dateFormatter.amSymbol = amSymbol
        }
        if let pmSymbol = pm {
            dateFormatter.pmSymbol = pmSymbol
        }
            
        return dateFormatter.string(from: self)
    }
    
    func toKST() -> Date {
        var today = Date()
        let format = "yyyyMMddHHmmssSSS"
        let date = self.toString(format)
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = TimeZone(secondsFromGMT: -9 * 60 * 60)
        if let value = formatter.date(from: date) {
            today = value
        }
        
        return today
    }
}
