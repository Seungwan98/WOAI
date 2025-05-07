//
//  DateFormatter.swift
//  WOAI
//
//  Created by 양승완 on 4/29/25.
//
import Foundation
class TimeManager {
    
    
    static let shared = TimeManager()
    
    private init() {}

    let inputFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul") // 타임존 설정 (서울)
        return dateFormatter
    }()
    
    func getOnlyTimes(inputDate: Date) -> String {
        inputFormatter.dateFormat = "HH:mm"
        return inputFormatter.string(from: inputDate)
        
    }
    
    func getUntilDays(inputDate: Date) -> String {
        inputFormatter.dateFormat = "yyyy-MM-dd"
        return inputFormatter.string(from: inputDate)
    }
    
    func getUntilDaysDate(inputDate: String) -> Date? {
        inputFormatter.dateFormat = "yyyy-MM-dd"
        return inputFormatter.date(from: inputDate)
        
    }
    
    
        
    
}
