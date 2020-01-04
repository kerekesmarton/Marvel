//
//  Additions
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation

public class DateFormatters {
    
    private init() {}
    
    public static var dayMonthFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d-MM"
        return dateFormatter
    }()
    
    public static var shortDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        return dateFormatter
    }()
    
    public static var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()    
    
    public static var serverDateTimeFormatter1: DateFormatter = {
        let dateTimeFormatter = DateFormatter()
        dateTimeFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateTimeFormatter
        ////2018-09-25T10:01:13.872Z
    }()
    
    public static var serverDateTimeFormatter2: DateFormatter = {
        let dateTimeFormatter = DateFormatter()
        dateTimeFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        return dateTimeFormatter
        ////2018-09-25T10:01:13.872SSSZ
    }()
    
    public static var serverDateTimeFormatter3: DateFormatter = {
        let dateTimeFormatter = DateFormatter()
        dateTimeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
        return dateTimeFormatter
        //2019-07-17 13:30:37 +0000
    }()
    
    public static var relativeDateFormatter: DateFormatter = {
        let relativeDateFormatter = DateFormatter()
        relativeDateFormatter.dateStyle = .short
        relativeDateFormatter.timeStyle = .short
        relativeDateFormatter.doesRelativeDateFormatting = true
        return relativeDateFormatter
    }()
    
    public static var timeFormatter: DateFormatter  = {
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .long
        
        return timeFormatter
    }()
    
    public static var shortTimeFormatter: DateFormatter  = {
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short
        
        return timeFormatter
    }()
}


extension Date {
    func noMinutes() -> Date {
        let calendar = Calendar(identifier: .gregorian)
        var components = calendar.dateComponents([.year,.month,.day,.hour,.minute], from: self)
        components.setValue(0, for: .minute)
        return calendar.date(from: components)!
    }
    
    func noHours() -> Date {
        let calendar = Calendar(identifier: .gregorian)
        var components = calendar.dateComponents([.year,.month,.day,.hour,.minute], from: self)
        components.setValue(0, for: .hour)
        components.setValue(0, for: .minute)
        return calendar.date(from: components)!
    }
    
    func setting(hour toHour: Int) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        var components = calendar.dateComponents([.year,.month,.day,.hour,.minute], from: self)
        components.setValue(toHour, for: .hour)
        components.setValue(0, for: .minute)
        return calendar.date(from: components)!
    }
    
    func setting(dayofWeek toDay: Int) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        var components = calendar.dateComponents([.year,.month,.day,.hour,.minute], from: self)
        components.setValue(toDay, for: .day)
        components.setValue(0, for: .hour)
        components.setValue(0, for: .minute)
        return calendar.date(from: components)!
    }
    
    func setting(month toMonth: Int) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        var components = calendar.dateComponents([.year,.month,.day,.hour,.minute], from: self)
        components.setValue(toMonth, for: .month)
        components.setValue(0, for: .day)
        components.setValue(0, for: .hour)
        components.setValue(0, for: .minute)
        return calendar.date(from: components)!
    }
}

extension DateComponents{
    public func getLargerComponent() -> Calendar.Component? {
        if let year = self.year, year > 0 {
            return .year
        }else if let month = self.month, month > 0 {
            return .month
        }else if let day = self.day, day > 0 {
            return .day
        }else if let hour = self.hour, hour > 0 {
            return .hour
        }else if let minute = self.minute, minute > 0 {
            return .minute
        }
        
        return nil
    }
    
    public func getValueFor(component: Calendar.Component?) -> Int? {
        guard let component = component else {
            return nil
        }
        
        switch component {
        case .year:
            return self.year
        case .month:
            return self.month
        case .day:
            return self.day
        case .hour:
            return self.hour
        case .minute:
            return self.minute
        default:
            return nil
        }
    }
    
    public func getStringRepresentationFor(component: Calendar.Component?) -> String? {
        guard let dateComponent = component else {
            return nil
        }
        var date = ""

        switch dateComponent {
        case .year:
            guard let year =  self.year else {
                return nil
            }
            (year > 1) ? date.append("date_years".localised) : date.append("date_year".localised)
        case .month:
            guard let month =  self.month else {
                return nil
            }
            (month > 1) ? date.append("date_months".localised) : date.append("date_month".localised)
        case .day:
            guard let day =  self.day else {
                return nil
            }
            (day > 1) ? date.append("date_days".localised) : date.append("date_day".localised)
        case .hour:
            guard let hour =  self.hour else {
                return nil
            }
            (hour > 1) ? date.append("date_hours".localised) : date.append("date_hour".localised)
        case .minute:
            guard let minute =  self.minute else {
                return nil
            }
            (minute > 1) ? date.append("date_minutes".localised) : date.append("date_minute".localised)
        default:
            return nil
        }
        
        return date
    }
    
    public func getStringRepresentationForPeriod() -> String {

        var createdDate = ""
        let component = getLargerComponent()
        let value = getValueFor(component: component)
        let dateString = getStringRepresentationFor(component: component)
        
        if let dateValue = value, dateValue > 0, let valueDateString = dateString {
            let stringValue = String(dateValue)
            createdDate += stringValue
            createdDate += " "
            createdDate += valueDateString
        }else{
            createdDate = "now".localised
        }
        
        return createdDate
    }
}
