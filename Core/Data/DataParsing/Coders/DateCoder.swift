///
//  Core
//
//  Copyright © 2018 mkerekes. All rights reserved.
//

import Foundation
import Domain
import Additions

public class DateCoder: Codable {
    var formatters = [DateFormatters.serverDateTimeFormatter1, DateFormatters.serverDateTimeFormatter2, DateFormatters.serverDateTimeFormatter3]
    public let value: Date
    
    public init(date: Date?) throws {
        if let date = date {
            self.value = date
        }
        throw ServiceError.parsing("Date could not be parsed")        
    }
    
    public init(date: Date) {
        self.value = date
    }
    
    required public init(from decoder: Decoder) throws {
        guard let string = try? String(from: decoder) else {
            self.value = try Date(from: decoder)
            return
        }
        
        let date: Date? = formatters.reduce(nil) { (result, formatter) -> Date? in
            result ?? formatter.date(from: string)
        }
        
        if let date = date {
            self.value = date
        } else {
            let context = DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Invalid date format: \(string)")
            throw DecodingError.dataCorrupted(context)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        let dateString: String? = formatters.reduce(nil) { (result, formatter) -> String? in
            result ?? formatter.string(from: value)
        }
        if let dateString = dateString {
            try dateString.encode(to: encoder)
        } else {
            try value.encode(to: encoder)
        }
    }
}
