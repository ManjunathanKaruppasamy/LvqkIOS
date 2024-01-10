//
//  Date+Extension.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 23/03/23.
//

import Foundation
import UIKit

extension Date {
    var getTimeStamp: UInt64 {
      UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    }
    func getMonths(count: Int) -> Date? {
        let components: NSDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: self) as NSDateComponents
        components.day = 1
        components.month -= count
        
        return Calendar.current.date(from: components as DateComponents) ?? Date()
    }
    
    // Last Month End
    func getLastMonthEnd() -> Date? {
        let components: NSDateComponents = Calendar.current.dateComponents([.year, .month], from: self) as NSDateComponents
        components.day = 1
        components.day -= 1
        return Calendar.current.date(from: components as DateComponents) ?? Date()
    }
    
    // This Month Start
    func getThisMonthStart() -> Date? {
        var components = Calendar.current.dateComponents([.year, .month], from: self)
        components.day = 1
        return Calendar.current.date(from: components) ?? Date()
    }
    
}

// MARK: Convert MilliSeconds To Required DateFormat
func convertMilliSecondsToReqDateFormat(milliseconds: Double, dateformat: String? = nil) -> String {
    let milisecond = milliseconds
    let dateVar = Date.init(timeIntervalSinceNow: TimeInterval(milisecond)/1000)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateformat ?? "dd-MM-yyyy hh:mm"
    let value = (dateFormatter.string(from: dateVar) )
    return value
}

func convertTimeStampToDate(date: Int?, dateformat: String? = nil) -> String {
    if let timeResult = date {
        let unixTimeStamp: Double = Double(timeResult) / 1000.0
        let exactDate = NSDate.init(timeIntervalSince1970: unixTimeStamp)
        let dateFormatt = DateFormatter()
        dateFormatt.dateFormat = dateformat ?? "MMM dd-yyyy '-' hh:mm a"
        let localDate = dateFormatt.string(from: exactDate as Date)
        return localDate
    }
    return ""
}
