//
//  DateFormatter.swift
//  WOAI
//
//  Created by 양승완 on 4/29/25.
//
import Foundation
extension DateFormatter {
    func getOnlyTimes(inputDate: Date) -> String {

        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "HH:mm"
        inputFormatter.locale = Locale(identifier: "ko_KR") // 지역화 설정 (한국)
        inputFormatter.timeZone = TimeZone(identifier: "Asia/Seoul") // 타임존 설정 (서울)

        return inputFormatter.string(from: inputDate)
        
    }
    
    func getUntilDays(inputDate: Date) -> String {

        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        inputFormatter.locale = Locale(identifier: "ko_KR") // 지역화 설정 (한국)
        inputFormatter.timeZone = TimeZone(identifier: "Asia/Seoul") // 타임존 설정 (서울)

        return inputFormatter.string(from: inputDate)
        
    }
        
    
}
