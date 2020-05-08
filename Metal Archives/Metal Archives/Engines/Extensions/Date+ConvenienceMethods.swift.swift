//
//  Date+Distance.swift
//  Metal Archives
//
//  Created by Thanh-Nhon Nguyen on 29/01/2019.
//  Copyright © 2019 Thanh-Nhon Nguyen. All rights reserved.
//

import Foundation

extension Date {
    func distanceFromNow() -> (Int, String) {
        let dateNow = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.minute, .hour, .day, .year], from: self, to: dateNow)

        let year = components.year!
        let day = components.day!
        let hour = components.hour!
        let minute = components.minute!
        
        let week = (year * 365 + day)/7
        let month = (year * 365 + day)/30
        
        if month == 1 {
            return (month, "month")
        } else if month > 1 {
            return (month, "months")
        }
        
        if week == 1 {
            return (week, "week")
        } else if week > 1 {
            return (week, "weeks")
        }
        
        if day == 1 {
            return (day, "day")
        } else if day > 1 {
            return (day, "days")
        }
        
        if hour == 1 {
            return (hour, "hour")
        } else if hour > 1 {
            return (hour, "hours")
        }
    
        if minute == 1 {
            return (minute, "minute")
        } else {
            return (minute, "minutes")
        }
    }
    
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
}

extension Date {
    /// String must respect the following structure: September 12th, 2020
    init?(from string: String) {
        let dateElements = string.split(separator: " ", maxSplits: 3, omittingEmptySubsequences: true)
        
        // Ex: September 12th, 2020
        guard dateElements.count == 3 else { return nil }
        
        let monthString = dateElements[0]
        var dayString = dateElements[1]
        dayString.removeLast(3)
        
        let yearString = dateElements[2]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d/MMMM/yyyy"
        let dateString = "\(dayString)/\(monthString)/\(yearString)"
        
        if let date = dateFormatter.date(from: dateString) {
            self = date
        } else {
            return nil
        }
    }
}
